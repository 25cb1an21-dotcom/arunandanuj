# SpiceVilla — Web Technology Restaurant System

## Technology
- HTML5
- CSS3
- JavaScript (ES6)
- Browser LocalStorage for demo cart data
- Responsive UI

## Modules
- Premium public restaurant website
- Menu search and category filtering
- Customer interface
- Owner dashboard
- POS billing
- Kitchen Display System / KOT
- Table/reservation-ready interface
- GST billing UI with configurable CGST/SGST demo rates

The public homepage includes an illustrative POS and invoice preview; preview figures are examples, not live sales data. Inventory and staff management are not connected modules yet and are labeled as planned. Live owner workflows link to the database-backed POS, order, kitchen, menu, customer, payment, invoice, and report pages.

## Run the website
This application uses a Python API and a local SQLite database. Do not open HTML files directly or use a static-only Live Server: sign-in, ordering, and management data require the API.

1. Install Python 3.10+.
2. Install backend packages with `python -m pip install -r requirements.txt`.
3. Optionally copy `backend/.env.example` to `backend/.env` and change `SPICEVILLA_DB_PATH`. The default database file is `data/spicevilla.sqlite3`; the app creates it and seeds the menu on startup. Do not commit database files.
4. Start the website and API with `python backend/server.py`, then open `http://127.0.0.1:8000`.
5. Open **Owner Login → Create the owner account** on the restaurant computer to create the first owner account. Alternatively, create it from the project root with `python backend/create_owner.py`.

If npm is installed, `npm start` starts the API, `npm test` runs the database-independent checks, and `npm run create-owner` creates the first owner account.

No database server or database credentials are required.

Run the backend's database-independent checks from the project root with `python -m unittest discover -s backend -p "test_*.py"`.

## Deploy from GitHub

This is a full-stack application, not a static site: GitHub Pages cannot run its Python API. The included `render.yaml` deploys the complete app as one web service on Render. Push this project to GitHub, create a Render account, and use **New → Blueprint** to connect the repository and apply `render.yaml`.

Render creates a persistent disk at `/var/data` and stores the SQLite database at `/var/data/spicevilla.sqlite3`. No external database service or database credentials are needed. The persistent disk is required to preserve accounts and orders across deploys; check Render's current disk pricing and plan requirements. Wait for `/api/health` to pass, then open the Render service URL.

Create the first owner from a trusted machine with the Render database file available, using `python backend/create_owner.py` in a Render shell. The public owner bootstrap is intentionally restricted to loopback and is not available on the deployed site. If using Google sign-in, set `GOOGLE_CLIENT_ID` in the Render environment and add the deployed HTTPS origin to the Google OAuth client's authorized JavaScript origins.

The service uses the host-provided `PORT`, binds to `0.0.0.0`, and enables secure session cookies. Back up the SQLite database file independently. Uploaded images are stored under `uploads/`; use persistent storage or an external image service if uploads must survive application redeploys. The app records payments but does not process them, and its sample GST rates must be reviewed before real use.

GitHub Actions runs the backend test suite on pushes and pull requests. Locally, run it with `python -m unittest discover -s backend -p "test_*.py"`.

### Local Windows setup
Run `.\start-local.ps1` from PowerShell to start the app. The database is created automatically at `data\spicevilla.sqlite3` and persists on your computer. Press Ctrl+C in that PowerShell window to stop the app.

The web-based owner signup is a one-time bootstrap: it works only from a loopback connection on the restaurant computer and only while no owner account exists. Create additional owner accounts with the administrator-only `backend/create_owner.py` command.

## Demo navigation
Home → Customer / Order Online
Login → Customer interface
Owner Portal → Owner dashboard
Owner Dashboard → POS / Billing Workspace / Kitchen

Menu cards open a dedicated dish details page. Orders lead to an order confirmation and can be tracked from the customer interface. Issued customer invoices can be opened and printed or saved as PDF from the browser print dialog.

## Billing workspace
Owners use **Billing Workspace** from the owner dashboard to search all orders, issue GST invoices, record payments, and manage outstanding balances. Customers have a separate **My Billing** page with only their account's invoices and payment summary; they can open or print each invoice. Invoice rates are sample values and payment records are not a real payment gateway; no UPI or card payment is processed.

## Google customer sign-in
Open [Google Cloud Credentials](https://console.cloud.google.com/apis/credentials), configure the OAuth consent screen, and create an OAuth client ID for a **Web application**. Add `http://127.0.0.1:8000` as an authorized JavaScript origin. Set `GOOGLE_CLIENT_ID` in `backend/.env` to the public client ID and restart SpiceVilla. The login page displays setup instructions while this value is blank; the server validates Google ID tokens before creating or signing in a customer. Never add a client secret to the website.

## Backend API and limitations
The API persists menu, account, order, invoice, payment, reservation, and report data in SQLite. Customer passwords are stored as PBKDF2 hashes; server-side sessions use HttpOnly cookies. Sample GST rates are 2.5% CGST and 2.5% SGST and must be reviewed before production. Payment entries are records only—no UPI/card gateway is connected.
