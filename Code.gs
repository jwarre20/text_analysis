const HEADERS = [
  "Submitted At",
  "Submission ID",
  "Player Email",
  "Character Name",
  "Class",
  "Ancestry",
  "Character Sheet",
  "Character Data (JSON)",
  "Email Status",
  "Last Error"
];

function doPost(event) {
  const lock = LockService.getScriptLock();
  if (!lock.tryLock(10000)) {
    return jsonResponse({ ok: false, message: "The save service is busy. Please retry." });
  }

  try {
    const request = JSON.parse(event.postData.contents);
    const properties = PropertiesService.getScriptProperties();
    const expectedToken = properties.getProperty("SAVE_TOKEN");
    const spreadsheetId = properties.getProperty("SPREADSHEET_ID");

    if (!expectedToken || !constantTimeEquals(request.token || "", expectedToken)) {
      return jsonResponse({ ok: false, message: "The save service rejected this request." });
    }

    validateRequest(request);
    if (!spreadsheetId) {
      throw new Error("The spreadsheet ID has not been configured.");
    }

    const spreadsheet = SpreadsheetApp.openById(spreadsheetId);
    const sheet = spreadsheet.getSheetByName("Characters") ||
      spreadsheet.insertSheet("Characters");
    ensureHeaders(sheet);

    const existingRow = findSubmissionRow(sheet, request.submission_id);
    let row;
    if (existingRow) {
      row = existingRow;
      if (sheet.getRange(row, 9).getValue() === "SENT") {
        return jsonResponse({ ok: true, message: "Character was already saved and emailed." });
      }
    } else {
      row = sheet.getLastRow() + 1;
      sheet.getRange(row, 1, 1, HEADERS.length).setValues([[
        new Date(),
        request.submission_id,
        spreadsheetText(request.player_email),
        spreadsheetText(request.character.details.character_name),
        spreadsheetText(request.character.class),
        spreadsheetText(request.character.species),
        spreadsheetText(request.character_sheet),
        spreadsheetText(JSON.stringify(request.character)),
        "PENDING",
        ""
      ]]);
    }

    try {
      MailApp.sendEmail({
        to: request.player_email,
        subject: "Your Beneath the Blackwood character: " +
          request.character.details.character_name,
        body: "Your character has been saved to the campaign roster.\n\n" +
          request.character_sheet,
        name: "Beneath the Blackwood"
      });
      sheet.getRange(row, 9, 1, 2).setValues([["SENT", ""]]);
      return jsonResponse({ ok: true, message: "Character saved and emailed." });
    } catch (error) {
      sheet.getRange(row, 9, 1, 2).setValues([[
        "EMAIL_FAILED",
        String(error && error.message ? error.message : error).slice(0, 500)
      ]]);
      console.error("Email delivery failed for submission " + request.submission_id, error);
      return jsonResponse({
        ok: false,
        message: "The character was saved for the DM, but the email failed. Retry to send it again."
      });
    }
  } catch (error) {
    console.error("Character save failed", error);
    return jsonResponse({
      ok: false,
      message: "The character could not be saved. Check the DM's save-service setup and retry."
    });
  } finally {
    lock.releaseLock();
  }
}

function validateRequest(request) {
  if (!request || !/^[A-Za-z0-9-]{20,100}$/.test(request.submission_id || "")) {
    throw new Error("Invalid submission ID.");
  }
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(request.player_email || "")) {
    throw new Error("Invalid player email.");
  }
  if (!request.character ||
      !request.character.details ||
      !request.character.details.character_name ||
      !request.character.class ||
      !request.character.species ||
      typeof request.character_sheet !== "string" ||
      request.character_sheet.length > 20000) {
    throw new Error("Character data is incomplete or too large.");
  }
}

function ensureHeaders(sheet) {
  if (sheet.getLastRow() === 0) {
    sheet.getRange(1, 1, 1, HEADERS.length).setValues([HEADERS]);
    sheet.setFrozenRows(1);
    return;
  }

  const currentHeaders = sheet.getRange(1, 1, 1, HEADERS.length).getValues()[0];
  if (HEADERS.some(function (header, index) {
    return currentHeaders[index] !== header;
  })) {
    throw new Error("The Characters sheet has unexpected column headers.");
  }
}

function findSubmissionRow(sheet, submissionId) {
  if (sheet.getLastRow() < 2) {
    return null;
  }
  const match = sheet.getRange(2, 2, sheet.getLastRow() - 1, 1)
    .createTextFinder(submissionId)
    .matchEntireCell(true)
    .findNext();
  return match ? match.getRow() : null;
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

function spreadsheetText(value) {
  const text = String(value);
  return /^[=+\-@]/.test(text) ? "'" + text : text;
}

function jsonResponse(data) {
  return ContentService.createTextOutput(JSON.stringify(data))
    .setMimeType(ContentService.MimeType.JSON);
}
