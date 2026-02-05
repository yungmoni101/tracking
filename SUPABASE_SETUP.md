# AeroTrack Supabase Setup Guide

## Step 1: Create a Supabase Account
1. Go to https://supabase.com
2. Sign up for a free account
3. Create a new project
4. Note down your project URL and anon/public key

## Step 2: Create Database Tables

Go to your Supabase dashboard → SQL Editor and run these commands:

### Table 1: trackings
```sql
CREATE TABLE trackings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tracking_number TEXT UNIQUE NOT NULL,
    shipped_date TEXT NOT NULL,
    service TEXT NOT NULL,
    shipment_category TEXT NOT NULL,
    receiver_name TEXT,
    delivery_location TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE trackings ENABLE ROW LEVEL SECURITY;

-- Create policy to allow all operations (for admin panel)
CREATE POLICY "Allow all operations on trackings" ON trackings
FOR ALL USING (true) WITH CHECK (true);
```

### Table 2: tracking_events
```sql
CREATE TABLE tracking_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tracking_id UUID REFERENCES trackings(id) ON DELETE CASCADE,
    event_date TEXT NOT NULL,
    event_time TEXT NOT NULL,
    event_title TEXT NOT NULL,
    event_description TEXT,
    event_location TEXT,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE tracking_events ENABLE ROW LEVEL SECURITY;

-- Create policy to allow all operations (for admin panel)
CREATE POLICY "Allow all operations on tracking_events" ON tracking_events
FOR ALL USING (true) WITH CHECK (true);

-- Create index for better performance
CREATE INDEX tracking_events_tracking_id_idx ON tracking_events(tracking_id);
CREATE INDEX tracking_events_sort_order_idx ON tracking_events(sort_order);
```

## Step 3: Configure admin.html

1. Open `admin.html`
2. Find these lines near the top of the JavaScript section:
   ```javascript
   const SUPABASE_URL = 'YOUR_SUPABASE_URL';
   const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY';
   ```

3. Replace with your actual Supabase credentials:
   - `SUPABASE_URL`: Found in Settings → API → Project URL
   - `SUPABASE_ANON_KEY`: Found in Settings → API → Project API keys → anon/public

Example:
```javascript
const SUPABASE_URL = 'https://abcdefghijklmnop.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
```

## Step 4: How to Use the Admin Panel

### Creating a Tracking Number
1. Open `admin.html` in your browser
2. Click "Create Tracking Number" button
3. Fill in the required fields:
   - Tracking Number (e.g., 1Z2902E30419053424)
   - Shipped/Billed On (e.g., 10/28/2025)
   - Service (e.g., UPS Express Saver®)
   - Shipment Category (e.g., Package)
   - Receiver Name (optional)
   - Delivery Location (optional)
4. Click "Create Tracking"

### Adding Tracking Events
1. Click on a tracking number from the left sidebar
2. Click "+ Add Event" button
3. Fill in the event details:
   - Date (e.g., 11/05/2025)
   - Time (e.g., 3:23 PM)
   - Event Title (e.g., Delivered)
   - Event Description (e.g., DELIVERED)
   - Location (e.g., MONTREAL, CA)
4. Click "Save Event"

### Editing/Deleting
- Click "Edit" on any event to modify it
- Click "Delete" to remove an event
- Click "Delete Tracking" to remove the entire tracking number and all its events

## Step 5: Connect to Your Website

To display the tracking data on your website (track.html and tracking.html), you'll need to:

1. Add Supabase to your tracking pages
2. Fetch data from Supabase instead of hardcoded data
3. Use the tracking number from URL parameters to query the correct data

Would you like me to update track.html and tracking.html to fetch data from Supabase?

## Security Notes

⚠️ **Important**: The current setup allows anyone to access the admin panel. For production:

1. Add authentication to admin.html
2. Update RLS policies to restrict access
3. Consider creating separate admin and public API keys
4. Add password protection or move admin panel to a secure location

## Troubleshooting

### Error: "relation 'trackings' does not exist"
- Make sure you ran both SQL commands in Supabase SQL Editor
- Refresh your browser and try again

### Error: "Invalid API key"
- Double-check your SUPABASE_URL and SUPABASE_ANON_KEY
- Make sure there are no extra spaces or quotes
- Verify the keys in your Supabase dashboard

### Events not appearing
- Check sort_order in the database
- Events are ordered by sort_order descending (newest first)
- Make sure tracking_id matches the parent tracking record
