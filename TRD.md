# Technical Requirement Document (TRD)

# Product

**RuCare – Cupping Therapy Clinic Application**

---

# 1. System Architecture Overview

RuCare will follow a **serverless architecture** using Firebase services. This approach removes the need for a traditional backend server and allows the application to scale automatically.

### High-Level Architecture

```
Mobile / Web App (React / Flutter)
        │
        │ Firebase SDK
        ▼
Firebase Services
   ├── Firebase Authentication
   ├── Cloud Firestore Database
   ├── Firebase Storage
   ├── Firebase Cloud Functions
   └── Firebase Cloud Messaging
```

### Core Components

#### 1. Frontend Application

The mobile or web client that users interact with.

Technologies:

* React (Web prototype)
* Flutter / React Native (future mobile app)

Responsibilities:

* UI rendering
* User interactions
* Calling Firebase services

---

#### 2. Firebase Authentication

Used to manage user identity and access.

Supported login methods:

* Email and password
* Phone authentication (optional future feature)

Roles stored in user profile:

* User
* Doctor
* Admin

---

#### 3. Cloud Firestore Database

Firestore will store all application data such as:

* Users
* Therapies
* Appointments
* Products
* Orders
* Courses
* Enrollments

Firestore is a **NoSQL document database** designed for scalability.

---

#### 4. Firebase Storage

Used to store media files including:

* Therapy images
* Product images
* Course images

---

#### 5. Firebase Cloud Functions

Serverless backend logic used for:

* Appointment validation
* Preventing double bookings
* Inventory updates
* Payment verification (future)

---

#### 6. Firebase Cloud Messaging

Used for push notifications in future versions.

Example notifications:

* Appointment reminders
* Order confirmation
* Course enrollment confirmation

---

# 2. Frontend Responsibilities

The frontend will handle **UI, navigation, and Firebase interactions**.

### Authentication

* User signup
* User login
* Logout
* Token/session management

### Therapy Module

* Fetch therapy list
* Display therapy details
* Start booking process

### Appointment Booking

* Display available time slots
* Submit appointment booking
* Display appointment history

### Store Module

* Browse products
* Add items to cart
* Place order

### Courses Module

* Browse courses
* View course details
* Enroll in courses

### Profile Module

* Update user details
* View appointments
* View orders
* View course enrollments

---

# 3. Backend Responsibilities (Firebase Services)

Backend responsibilities will be handled through Firebase services and Cloud Functions.

### Authentication Service

Handles:

* User registration
* Login validation
* Token management
* Role-based access

---

### Appointment Management

Functions include:

* Create appointment
* Validate selected time slot
* Prevent duplicate bookings
* Allow cancellation
* Mark appointment completed (doctor role)

---

### Product Order Management

Responsibilities:

* Manage product inventory
* Process orders
* Update order status
* Prevent ordering out-of-stock products

---

### Course Enrollment Management

Responsibilities:

* Manage course listings
* Enroll users in courses
* Enforce course capacity limits

---

# 4. Firestore Database Structure

Firestore uses **collections and documents** instead of tables.

---

# Users Collection

```
users
   ├── userId
       ├── name
       ├── email
       ├── phone
       ├── role (user / doctor / admin)
       ├── createdAt
```

---

# Therapies Collection

```
therapies
   ├── therapyId
       ├── name
       ├── description
       ├── benefits
       ├── precautions
       ├── duration
       ├── price
       ├── imageUrl
```

Example therapies:

* Dry Cupping
* Wet Cupping (Hijama)
* Fire Cupping
* Leech Therapy
* Acupuncture
* Kasa Thali Therapy

---

# Appointments Collection

```
appointments
   ├── appointmentId
       ├── userId
       ├── therapyId
       ├── doctorId
       ├── date
       ├── timeSlot
       ├── status
       ├── createdAt
```

Status values:

* booked
* completed
* cancelled

---

# Products Collection

```
products
   ├── productId
       ├── name
       ├── size
       ├── description
       ├── price
       ├── stock
       ├── imageUrl
```

Products include:

* Talbina with Dry Fruits
* Olive Oil
* Sirka (Vinegar)
* Ajwah Khajoor Powder
* Badam Oil
* Shilajit
* Zafran

---

# Orders Collection

```
orders
   ├── orderId
       ├── userId
       ├── products[]
       ├── totalPrice
       ├── paymentMethod
       ├── orderStatus
       ├── createdAt
```

Order status:

* pending
* confirmed
* delivered
* cancelled

---

# Courses Collection

```
courses
   ├── courseId
       ├── title
       ├── description
       ├── instructor
       ├── duration
       ├── price
       ├── capacity
```

Example courses:

* Basic Hijama Course
* Advanced Cupping Therapy Course

---

# Course Enrollments Collection

```
courseEnrollments
   ├── enrollmentId
       ├── userId
       ├── courseId
       ├── status
       ├── enrolledAt
```

---

# Cart Collection

```
carts
   ├── cartId
       ├── userId
       ├── items[]
```

---

# 5. API / Data Access Structure

Instead of REST APIs, the frontend will communicate directly with Firebase services using the **Firebase SDK**.

Example operations:

Fetch therapies

```
firestore.collection("therapies").get()
```

Book appointment

```
firestore.collection("appointments").add()
```

Fetch products

```
firestore.collection("products").get()
```

Enroll in course

```
firestore.collection("courseEnrollments").add()
```

---

# 6. Authentication Strategy

Authentication will be implemented using **Firebase Authentication**.

Login flow:

```
User enters email/password
        ↓
Firebase verifies credentials
        ↓
Firebase returns authentication token
        ↓
Frontend stores session
```

---

# Role-Based Access Control

User roles stored in Firestore:

```
user
doctor
admin
```

Permissions:

| Role   | Permissions                                    |
| ------ | ---------------------------------------------- |
| User   | Book therapies, order products, enroll courses |
| Doctor | View appointments, mark completed              |
| Admin  | Manage therapies, products, courses            |

---

# 7. Third-Party Dependencies

External services used in RuCare:

| Service                  | Purpose             |
| ------------------------ | ------------------- |
| Firebase Authentication  | User authentication |
| Cloud Firestore          | Database            |
| Firebase Storage         | Image storage       |
| Firebase Cloud Functions | Backend logic       |
| Razorpay (future)        | Online payments     |

---

# 8. Scalability Considerations

Firebase automatically scales with traffic.

Key advantages:

* Serverless architecture
* Automatic database scaling
* Built-in caching
* Global CDN support

---

### Concurrency Protection

Cloud Functions will enforce rules to prevent:

* Double booking appointments
* Product overselling
* Course over-enrollment

---

# 9. Security Considerations

Important security measures:

### Password Protection

Handled by Firebase Authentication.

### Firestore Security Rules

Access control rules will restrict data access.

Example:

```
allow read: if request.auth != null
allow write: if request.auth.uid == userId
```

---

### Data Validation

Cloud Functions will validate:

* Appointment booking
* Order creation
* Course enrollment

---

# 10. Deployment Architecture

Final architecture for RuCare MVP:

```
React / Flutter App
        │
        ▼
Firebase Authentication
        │
        ▼
Cloud Firestore Database
        │
        ▼
Firebase Storage
        │
        ▼
Cloud Functions
```

---

# 11. MVP Development Stack

Frontend

* React (current prototype)
* Flutter or React Native (future mobile)

Backend

* Firebase

Database

* Cloud Firestore

Storage

* Firebase Storage

Authentication

* Firebase Authentication

---

# 12. Architecture Philosophy

RuCare’s architecture follows these principles:

* **Simple MVP development**
* **Minimal backend maintenance**
* **Fast deployment**
* **Automatic scaling**
* **Secure authentication**

The system avoids:

* Complex microservices
* Large backend servers
* Heavy infrastructure management

These can be introduced later if the platform grows significantly.


