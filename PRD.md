Here is a **structured Product Requirement Document (PRD)** for **Ruh-Care**, focused on a **practical V1 (MVP)** without unnecessary features.

---

# Product Requirement Document (PRD)

## Product Name

**Ruh-Care – Cupping Therapy Clinic Application**

---

# 1. Problem Statement

Many cupping therapy clinics currently manage **appointments, therapies, and product sales manually** through phone calls, WhatsApp, or in-person visits. This creates several problems:

* Patients cannot easily **discover available therapies** and their benefits.
* Appointment booking is **time-consuming and unorganized**.
* Clinics struggle with **managing schedules and patient flow**.
* Health products sold by the clinic are **not accessible online**.
* Doctors lack a simple system to **track equipment and therapy inventory**.

There is a need for a **simple digital platform** that allows patients to learn about therapies, book appointments, and purchase wellness products while helping the clinic manage its operations.

---

# 2. Product Goal

Create a **simple and reliable mobile application** that enables:

* Patients to **discover therapies and book appointments**
* Clinics to **manage appointments and therapy availability**
* Customers to **buy natural wellness products**
* Doctors to **track clinic equipment and supplies**

---

# 3. Target Users

## 1. Patients / Customers

People looking for alternative therapies or Hijama treatment.

Needs:

* Learn about therapies
* Book appointments
* Buy wellness products
* View appointment history

---

## 2. Doctors / Clinic Staff

Therapists performing cupping therapy.

Needs:

* View appointment schedule
* Manage therapy services
* Track clinic supplies and equipment

---

## 3. Admin (Clinic Owner)

Person managing the clinic operations.

Needs:

* Manage therapies
* Manage products
* Track bookings
* Track inventory

---

# 4. Therapies Offered

The application will list the following therapies:

1. Dry Cupping
2. Wet Cupping (Hijama)
3. Fire Cupping
4. Leech Therapy
5. Acupuncture
6. Kasa Thali Therapy

Each therapy includes:

* Description
* Benefits
* Duration
* Price
* Precautions

---

# 5. Product Catalog (Customer Store)

The store will sell the following **Ruh-Care products**:

| Product                      | Size  | Price |
| ---------------------------- | ----- | ----- |
| Talbina with Dry Fruits      | 250g  | ₹300  |
| Olive Oil                    | 500ml | ₹900  |
| Olive Oil                    | 200ml | ₹330  |
| Sirka (Anar & Olive Vinegar) | 500ml | ₹300  |
| Ajwah Khajoor Powder         | 100g  | ₹600  |
| Badam Oil (Spain)            | 100ml | ₹370  |
| Shilajit                     | 10g   | ₹500  |
| Zafran                       | 1g    | ₹450  |

---

# 6. Clinic Equipment Inventory

Tracked internally by the clinic:

* Hijama Cups (Size 1-6)
* Manual Pump
* Pump Machine
* Lancet Pen
* Lancet Pins
* Surgical Blade
* Tissue
* Rubber Facial Cups

Purpose:

* Track stock
* Notify low inventory

---

# 7. Core User Flows

## Flow 1 — Discover Therapy

User opens app
→ Home screen
→ View therapy list
→ Select therapy
→ Read description & benefits

---

## Flow 2 — Book Appointment

User
→ Select therapy
→ Select date
→ Select available time
→ Confirm booking

System
→ Save appointment
→ Notify clinic

---

## Flow 3 — Buy Products

User
→ Open store
→ Browse products
→ Add to cart
→ Checkout
→ Place order

---

## Flow 4 — Doctor Manage Appointments

Doctor
→ Login
→ View today's appointments
→ View patient details
→ Mark appointment completed

---

## Flow 5 — Admin Manage Products

Admin
→ Login
→ Add or update product
→ Update price
→ Manage stock

---

# 8. Feature List

## MVP (Version 1)

### User Features

* User registration/login
* View therapy list
* Therapy details page
* Book appointment
* View upcoming appointments
* Product store
* Add to cart
* Place order

---

### Doctor Features

* View appointment schedule
* View patient bookings
* Mark appointment completed

---

### Admin Features

* Add/edit therapies
* Add/edit products
* View orders
* Manage inventory
* View appointment list

---

## Future Features (Post-MVP)

* Online payments
* Push notifications
* Patient medical history
* Multi-clinic support
* Delivery tracking
* Therapy progress tracking
* Patient reviews
* Subscription for therapies
* AI therapy recommendations

---

# 9. Edge Cases

1. **Double booking**
   Two users book same slot.

Solution:

* Lock slot once selected.

---

2. **Appointment cancellation**

User cancels appointment.

Solution:

* Allow cancellation before fixed time.

---

3. **Out of stock product**

User tries to buy unavailable product.

Solution:

* Disable purchase when stock = 0.

---

4. **Doctor unavailable**

Therapist unavailable on selected date.

Solution:

* Disable those dates.

---

5. **Internet failure**

User loses connection during booking.

Solution:

* Retry mechanism before confirmation.

---

# 10. Non-Goals (V1)

The following will **NOT be included in Version 1**:

* AI diagnosis
* Telemedicine video calls
* Insurance integration
* Complex medical record system
* Multi-language support
* Multiple clinic branches
* Marketplace for other clinics

---

# 11. Success Metrics

The success of Ruh-Care V1 will be measured using:

### Adoption Metrics

* Number of registered users
* Number of app downloads

### Usage Metrics

* Appointments booked per week
* Product orders per week

### Business Metrics

* Revenue from therapies
* Revenue from product sales

### Operational Metrics

* Reduction in manual bookings
* Clinic schedule utilization

---

# 12. MVP Scope Summary

Version 1 focuses on **three core capabilities**:

1. Therapy discovery
2. Appointment booking
3. Product purchasing

Everything else is **secondary and planned for later versions**.

---

If you want, I can also help you create the **next product documents**, which would make your project **look like a real startup product**, such as:

* **System Architecture**
* **Database Schema**
* **User Journey Map**
* **Wireframes for all app screens**
* **Flutter app screen structure**
* **Pitch deck for Ruh-Care**.
