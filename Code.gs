function doPost(event) {
  const lock = LockService.getScriptLock();
  if (!lock.tryLock(10000)) {
    return jsonResponse({ ok: false, message: "The email service is busy. Please retry." });
  }

  let temporaryDocumentId = null;
  try {
    const request = JSON.parse(event.postData.contents);
    const properties = PropertiesService.getScriptProperties();
    const expectedToken = properties.getProperty("SAVE_TOKEN");
    const dmEmail = properties.getProperty("DM_EMAIL");

    if (!expectedToken || !constantTimeEquals(request.token || "", expectedToken)) {
      return jsonResponse({ ok: false, message: "The email service rejected this request." });
    }

    validateRequest(request, dmEmail);
    const cache = CacheService.getScriptCache();
    const cacheKey = submissionCacheKey(request.submission_id);
    if (cache.get(cacheKey)) {
      return jsonResponse({ ok: true, message: "This character PDF was already emailed." });
    }

    const document = DocumentApp.create("Character sheet - " + request.character_name);
    temporaryDocumentId = document.getId();
    document.getBody().setText(request.character_sheet);
    document.saveAndClose();

    const safeName = request.character_name
      .replace(/[^A-Za-z0-9 _-]/g, "")
      .trim() || "Character";
    const pdf = DriveApp.getFileById(temporaryDocumentId)
      .getAs(MimeType.PDF)
      .setName(safeName + "-character-sheet.pdf");
    const subject = "Beneath the Blackwood character: " + safeName;

    MailApp.sendEmail({
      to: request.player_email,
      subject: subject,
      body: "Your character sheet is attached as a PDF.",
      name: "Beneath the Blackwood",
      attachments: [pdf]
    });

    if (request.player_email.toLowerCase() !== dmEmail.toLowerCase()) {
      MailApp.sendEmail({
        to: dmEmail,
        subject: subject,
        body: "A player submitted this character sheet.",
        name: "Beneath the Blackwood",
        attachments: [pdf]
      });
    }

    cache.put(cacheKey, "sent", 21600);
    return jsonResponse({ ok: true, message: "Character PDF emailed to the player and DM." });
  } catch (error) {
    console.error("Character PDF email failed", error);
    return jsonResponse({
      ok: false,
      message: "The character PDF could not be emailed. Check the email service setup and retry."
    });
  } finally {
    if (temporaryDocumentId) {
      try {
        DriveApp.getFileById(temporaryDocumentId).setTrashed(true);
      } catch (cleanupError) {
        console.error("Could not move temporary character document to trash", cleanupError);
      }
    }
    lock.releaseLock();
  }
}

function validateRequest(request, dmEmail) {
  if (!request || !/^[A-Za-z0-9-]{20,100}$/.test(request.submission_id || "")) {
    throw new Error("Invalid submission ID.");
  }
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(request.player_email || "") ||
      !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(dmEmail || "")) {
    throw new Error("A valid player and DM email address are required.");
  }
  if (typeof request.character_name !== "string" ||
      !request.character_name.trim() ||
      typeof request.character_sheet !== "string" ||
      request.character_sheet.length > 20000) {
    throw new Error("Character data is incomplete or too large.");
  }
}

function submissionCacheKey(submissionId) {
  const digest = Utilities.computeDigest(
    Utilities.DigestAlgorithm.SHA_256,
    submissionId
  );
  return "sent_" + Utilities.base64EncodeWebSafe(digest).replace(/=/g, "");
}

function constantTimeEquals(actual, expected) {
  if (typeof actual !== "string" || typeof expected !== "string") {
    return false;
  }
  let difference = actual.length ^ expected.length;
  const length = Math.max(actual.length, expected.length);
  for (let index = 0; index < length; index += 1) {
    difference |= (actual.charCodeAt(index) || 0) ^ (expected.charCodeAt(index) || 0);
  }
  return difference === 0;
}

function jsonResponse(data) {
  return ContentService.createTextOutput(JSON.stringify(data))
    .setMimeType(ContentService.MimeType.JSON);
}
