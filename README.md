# Rutvi & Rohan's Baby Gender Reveal Voting

A mobile-friendly baby reveal website with a live countdown, one online vote per email address, private results until reveal time, and automatic result emails.

## What's changed in this version

- Corrected the name to **Rutvi & Rohan** throughout the website and result email.
- Added Rutvi and Rohan's uploaded couple photo as `assets/rutvi-rohan-photo.jpg`.
- Kept the second photo frame ready for the ultrasound image (the ultrasound photo has not been supplied yet).
- Removed the paper ballot / in-person voting section, the host PIN form, its JavaScript handler, and the in-person Edge Function source.
- Online voting remains: first name, last name, future relationship (“To be…”), email, and Boy/Girl prediction.
- Email addresses are not verified; the database blocks a second vote using the same normalized email address.

## Important: update the existing GitHub Pages site

This package is prepared for your existing repository/site:

`https://rohan9490.github.io/ruvti-rohan-gender-reveal-v2/`

The existing URL has the old spelling in its repository slug; that part is deliberately unchanged so your link keeps working. The visible website name is corrected to Rutvi. Do **not** create a new repository or rename the existing repository. Extract this ZIP, open the `Rutvi-Rohan-Gender-Reveal-v3` folder, and upload/replace the **contents** of that folder in the root of your existing `ruvti-rohan-gender-reveal-v2` repository. Keep the folder structure, especially `assets/` and `supabase/`.

In GitHub, commit the changes to the same branch currently used by Pages (usually `main`). GitHub Pages will rebuild the page. Your public URL stays the same.

## The two photo spaces

- Parents photo is already installed: `assets/rutvi-rohan-photo.jpg`.
- Ultrasound placeholder: `assets/baby-photo-placeholder.svg`. When you send the ultrasound image, replace this file or update its `<img src>` in `index.html` to the new image filename.

## Voting data and Excel

Once Supabase is connected and the form is successfully accepting votes, records are stored in `public.votes` in your Supabase project. To export them:

1. Open the Supabase Dashboard and select your project.
2. Go to **Table Editor → public → votes** and choose **Export / Download CSV**, or run `supabase/export-votes.sql` in **SQL Editor**.
3. Open the CSV in Excel and use **Save As → Excel Workbook (.xlsx)**.

Keep the spreadsheet private because it contains names and email addresses.

## Supabase setup

The scheduled job identifier in `supabase/cron.sql` retains its original internal name to avoid creating a duplicate schedule in a project where that job may already exist. It is not shown to guests.

The project uses three Edge Functions:

- `submit-vote` — records an online vote and rejects an email already used.
- `get-results` — returns the vote totals only after the reveal time.
- `send-reveal-results` — emails the final tally to recorded email addresses after the reveal.

The actual reveal deadline is **November 15, 2026 at 10:00 AM Mountain Time**, using `America/Edmonton` in the browser and `2026-11-15T17:00:00Z` server-side.

### New Supabase project

1. Create a Supabase project.
2. Run `supabase/schema.sql` in Supabase **SQL Editor**.
3. Put only the Supabase project URL and public publishable/anon key in `event-config.js`.
4. Deploy the Edge Functions from the project folder:

```bash
supabase login
supabase link --project-ref YOUR_PROJECT_REF
supabase functions deploy submit-vote --no-verify-jwt
supabase functions deploy get-results --no-verify-jwt
supabase functions deploy send-reveal-results --no-verify-jwt
```

5. Configure the Resend API key and verified sender address as private Supabase secrets. Do not put service-role keys, Resend keys, cron secrets, or other private credentials in GitHub.
6. Configure the scheduled result-email job using `supabase/cron.sql` and the instructions in your original Supabase setup. The schedule must use the original project URL and private cron secret.

### Existing Supabase project

If you previously deployed the in-person voting Edge Function:

1. Run `supabase/remove-paper-ballot-option.sql` in Supabase SQL Editor. It adds a constraint that blocks any new `in_person` rows while preserving historical records.
2. Delete the old `in-person-vote` Edge Function in Supabase Dashboard → **Edge Functions** if it is still deployed.
3. Deploy the updated `submit-vote` and `get-results` functions using the commands above. The result-email function is unchanged apart from the corrected family name in the email template, so deploy it too:

```bash
supabase functions deploy submit-vote --no-verify-jwt
supabase functions deploy get-results --no-verify-jwt
supabase functions deploy send-reveal-results --no-verify-jwt
```

Existing historical votes are not deleted. Any old in-person records remain identifiable in the database and CSV export, but the public page no longer offers paper ballots and no new in-person records are allowed after applying the migration.

## Before sharing with family

- Confirm `event-config.js` contains your real Supabase URL and public publishable/anon key.
- Confirm the three Edge Functions are deployed.
- Submit a test vote and confirm that it appears in `public.votes`.
- Submit again using the same email in a separate test and confirm it is rejected.
- Delete test rows before sharing the invitation.
- Test reveal email delivery before the event using a safe test setup; do not alter the production reveal deadline merely to test the live event.

## Privacy reminder

The public GitHub Pages URL is accessible to anyone who has the link. Email is not verified, so the unique-email rule prevents duplicate use of the same address but does not prove identity or prevent someone using another email. Keep Supabase service-role secrets, Resend keys, cron secrets, and database exports private.
