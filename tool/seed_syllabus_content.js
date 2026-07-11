#!/usr/bin/env node
/**
 * Seeds the `syllabus_content/{board}_{classCode}_{subjectCode}/{type}/{chapterId}`
 * Firestore collection from one or more JSON files.
 *
 * Input JSON schema (one file per class):
 * {
 *   "classCode": "class_10",
 *   "subjects": {
 *     "mathematics": [
 *       { "chapterId": "ch1", "chapterTitle": "Real Numbers",
 *         "fileUrl": "https://ncert.nic.in/textbook/pdf/jemh101.pdf" },
 *       ...
 *     ]
 *   },
 *   "unresolved": [ ... ]   // ignored by this script
 * }
 *
 * Usage:
 *   GOOGLE_APPLICATION_CREDENTIALS=./serviceAccount.json \
 *     node tool/seed_syllabus_content.js --type notes --board cbse data/cbse_notes_class_10.json [more files...]
 *
 *   Add --commit to actually write; without it the script only prints what it would do.
 */

const fs = require('fs');
const path = require('path');

function parseArgs(argv) {
  const args = { type: 'notes', board: 'cbse', commit: false, files: [] };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a === '--type') args.type = argv[++i];
    else if (a === '--board') args.board = argv[++i];
    else if (a === '--commit') args.commit = true;
    else if (a === '--key') args.key = argv[++i];
    else args.files.push(a);
  }
  return args;
}

async function main() {
  const args = parseArgs(process.argv.slice(2));
  if (args.files.length === 0) {
    console.error('Usage: node seed_syllabus_content.js [--type notes|pyqs] [--board cbse|icse|state] [--key serviceAccount.json] [--commit] <file.json> [file2.json ...]');
    process.exit(1);
  }
  if (!['notes', 'pyqs'].includes(args.type)) {
    console.error(`Invalid --type "${args.type}" (expected "notes" or "pyqs")`);
    process.exit(1);
  }

  const admin = require('firebase-admin');
  if (args.key) {
    admin.initializeApp({ credential: admin.credential.cert(require(path.resolve(args.key))) });
  } else {
    // Falls back to GOOGLE_APPLICATION_CREDENTIALS env var.
    admin.initializeApp({ credential: admin.credential.applicationDefault() });
  }
  const db = admin.firestore();

  let totalDocs = 0;
  let totalWritten = 0;

  for (const file of args.files) {
    const raw = JSON.parse(fs.readFileSync(path.resolve(file), 'utf8'));
    const classCode = raw.classCode;
    if (!classCode) {
      console.error(`Skipping ${file}: missing "classCode"`);
      continue;
    }

    for (const [subjectCode, chapters] of Object.entries(raw.subjects || {})) {
      const contentDocId = `${args.board}_${classCode}_${subjectCode}`;
      const col = db.collection('syllabus_content').doc(contentDocId).collection(args.type);

      let batch = db.batch();
      let batchCount = 0;

      for (const ch of chapters) {
        if (!ch.fileUrl) continue; // unresolved — skip, leaves it as "not available yet" in-app
        totalDocs++;

        const docRef = col.doc(ch.chapterId);
        const data = {
          chapterId: ch.chapterId,
          chapterTitle: ch.chapterTitle,
          title: ch.title || `${ch.chapterTitle} — NCERT PDF`,
          fileUrl: ch.fileUrl,
          fileType: 'pdf',
          isAvailable: true,
        };
        if (ch.board) data.board = ch.board; // PYQ-specific
        if (ch.year) data.year = ch.year;     // PYQ-specific

        console.log(`${args.commit ? 'WRITE' : 'DRY-RUN'} ${contentDocId}/${args.type}/${ch.chapterId} -> ${ch.fileUrl}`);

        if (args.commit) {
          batch.set(docRef, data, { merge: true });
          batchCount++;
          totalWritten++;
          if (batchCount >= 450) {
            await batch.commit();
            batch = db.batch();
            batchCount = 0;
          }
        }
      }

      if (args.commit && batchCount > 0) {
        await batch.commit();
      }
    }
  }

  console.log(`\n${totalDocs} chapter(s) with a fileUrl found across ${args.files.length} file(s).`);
  console.log(args.commit
    ? `${totalWritten} document(s) written to Firestore.`
    : 'Dry run only — re-run with --commit to write these to Firestore.');
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
