# 📝 Forms Flow (CU Plus Web App)

This document explains how the dynamic form system works across the frontend (Flutter) and backend (Node.js + Prisma), including recent improvements.

---

## 🧠 Overview

The Forms system allows:

- **Admins** → create and manage forms
- **Students** → fill, submit, and review forms

Forms are **fully dynamic**, meaning fields are created by admins and rendered by the frontend at runtime.

---

## 🔄 Full Flow

### 1. Admin Creates Form

Admin builds a form with:

- Title
- Description / Instructions
- Optional Year targeting
- Dynamic fields

Supported field types:

- `text` (short input)
- `textarea` (long input)
- `checkbox` (multiple options)
- `date`
- `year`
- `signature`

---

### 2. Form Stored in Database

Tables involved:

```
FormTemplate
FormField
```

Each field includes:

- `label`
- `type`
- `required`
- `sortOrder`
- `configJson` (e.g., checkbox options)

---

### 3. Student Views Forms

```http
GET /student/forms
```

Student sees:
- available forms
- forms filtered by year

---

### 4. Student Opens Form

```http
GET /student/forms/:id
```

Response:

```json
{
  "form": { ... },
  "submission": { ... } | null
}
```

---

### 5. Frontend Builds UI Dynamically

Based on `form.fields`, the UI is rendered dynamically:

| Type       | UI Component            |
|------------|-------------------------|
| text       | TextField               |
| textarea   | Multi-line TextField    |
| checkbox   | Checkbox list           |
| date       | Date picker             |
| year       | Numeric input (YYYY)    |
| signature  | Signature pad / image   |

---

### 6. Student Fills Form

State is stored in:

- TextEditingControllers
- Maps (checkbox, date, year)
- Signature pad (image capture)

---

### 7. Signature Upload Flow

1. Capture drawing → PNG (base64)
2. Send to:

```http
POST /student/forms/signature
```

3. Backend uploads to Cloudinary
4. Returns image URL

---

### 8. Submit Form

```http
POST /student/forms/:id/submissions
```

Payload:

```json
{
  "answers": [
    {
      "formFieldId": "...",
      "valueText": "..."
    }
  ]
}
```

Backend:

- creates `FormSubmission`
- stores answers in `FormAnswer`

---

## 🧾 Submission Storage

Tables:

```
FormSubmission
FormAnswer
```

Each answer stores:

- `valueText`
- `valueDate`
- `valueBoolean`
- `valueSignatureUrl`

---

## 🔒 Submission Rules

- One submission per student per form
- After submission:
  - form becomes read-only
  - submission cannot be modified

---

## 👁 Student Review Mode

When reopening a submitted form:

Frontend:

- loads submission data
- pre-fills all fields
- disables inputs
- displays signature image

---

## ✨ UX Improvements (Recent)

### 1. Selectable Text (Web)

- Forms are wrapped with `SelectionArea`
- Users can now:
  - highlight text
  - copy instructions
  - copy form content

---

### 2. Cleaner Form Builder Defaults

Admin form builder now:

- starts with empty values
- uses placeholders instead of real data
- improves first-time UX

---

### 3. Signature Handling (Improved)

- Stored as PNG in Cloudinary
- Replaces old signatures cleanly
- Uses URL instead of raw data

---

### 4. Payload Size Handling

- Backend increased limit to `10mb`
- Supports base64 signature uploads

---

## ⚠️ Common Issues

### 1. Submission Not Showing

Possible causes:
- frontend not reading `submission`
- API not returning submission

---

### 2. Signature Not Displaying

Possible causes:
- using signature pad instead of `Image.network`
- incorrect URL storage

---

### 3. Checkbox Issues

Fix:
- use `Set<String>` instead of boolean

---

### 4. Text Not Copyable (Web)

Fix:
- wrap content in `SelectionArea`
- use `SelectableText` where needed

---

## 🎯 Summary

- Forms are dynamic and backend-driven
- UI is generated at runtime
- Submission is normalized in DB
- Signature handled via Cloudinary
- Read-only mode enforced after submission
- Web UX improved with selectable text

---

This system provides a scalable, flexible form builder similar to Google Forms.