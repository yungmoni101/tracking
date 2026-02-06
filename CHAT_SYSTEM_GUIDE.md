# AeroTrack Live Chat System - Setup Guide

## Overview
This live chat system allows customers to chat with support directly from the tracking page. Messages are stored in Supabase for 2 hours and support staff can respond in real-time via the admin panel.

## Features
- ✅ Floating chat widget on tracking page
- ✅ Real-time messaging with Supabase
- ✅ Silent email notification to admin on first message
- ✅ Messages persist for 2 hours
- ✅ Admin panel with live chat interface
- ✅ Unread message badges
- ✅ Chat session management

---

## Step 1: Create Supabase Chat Tables

Go to your Supabase dashboard → SQL Editor and run the SQL file `CHAT_SETUP.sql` that was created in your project folder.

This will create:
- `chat_sessions` table - stores chat sessions with tracking numbers
- `chat_messages` table - stores all chat messages
- Indexes for performance
- Cleanup function for expired chats

---

## Step 2: Test the Setup

### Testing the Customer Chat (track.html)

1. Open a tracking page: `track.html?tracking=YOUR_TRACKING_NUMBER`
2. Click the blue chat button in the bottom right corner
3. The chat window will open showing:
   - "AeroTrack Virtual Assistant" welcome message
   - The tracking number in the header
   - Input field to type messages

4. Type a message and press Enter or click send
5. **On the first message**, an email notification will be sent to your admin email silently
6. The message will be saved to Supabase and visible in the admin panel

### Testing the Admin Chat (admin.html)

1. Open `admin.html` in your browser
2. Click the "💬 Live Chat" button in the top right
3. The chat panel will slide in from the right showing:
   - All active chat sessions
   - Unread message badges
   - Last message preview

4. Click on a chat session to view the conversation
5. Type a response and press Enter or click send
6. The customer will see your message in real-time (if they have the chat open)

---

## Step 3: How It Works

### Customer Side (track.html)

1. **Chat Button**: Floating blue button in bottom right
2. **Session Creation**: Creates a unique session ID when chat is opened
3. **Email Notification**: First message triggers silent email via Formspree
4. **Real-time Updates**: Subscribes to Supabase for live admin responses
5. **Message Storage**: All messages saved with 2-hour expiry
6. **Badge Notifications**: Shows unread count from admin

### Admin Side (admin.html)

1. **Chat Panel**: Slides in from right side
2. **Session List**: Shows all active chats with tracking numbers
3. **Unread Badges**: Red badges show unread customer messages
4. **Real-time Updates**: Automatically receives new customer messages
5. **Multi-chat Support**: Can switch between different customer chats
6. **Auto-refresh**: Checks for new chats every 30 seconds

---

## Step 4: Email Configuration

The chat system uses the same Formspree endpoint as your contact form:
- **Endpoint**: `https://formspree.io/f/xqedzwwe`
- **Email sent on**: First customer message in a new session
- **Email contains**: 
  - Tracking number
  - First message from customer
  - Session ID
  - Link to check admin panel

**Email is sent silently** - the customer doesn't see any loading or confirmation.

---

## Step 5: Message Retention (2 Hours)

Messages are automatically managed:
- Sessions expire after 2 hours
- Messages older than 2 hours are marked for deletion
- Run the cleanup function periodically:

```sql
SELECT cleanup_expired_chats();
```

### Setting Up Auto-cleanup (Optional)

You can set up a Supabase Edge Function or cron job to run the cleanup function automatically:

1. Create a PostgreSQL cron extension (if available)
2. Or use Supabase Edge Functions
3. Or manually run the cleanup SQL when needed

---

## Step 6: Customization

### Change Chat Colors

In `track.html`, find the chat styles and modify:
```css
.chat-button {
    background: #0066cc; /* Change to your brand color */
}
```

In `admin.html`, find the chat panel styles and modify:
```css
.chat-panel-header {
    background: #0066cc; /* Change to your brand color */
}
```

### Change Email Recipient

To change where chat notifications are sent:
1. Go to [Formspree Dashboard](https://formspree.io/forms)
2. Update the form settings
3. Or create a new form and update the endpoint in track.html:
   ```javascript
   fetch('https://formspree.io/f/YOUR_NEW_FORM_ID', {
   ```

### Modify Message Retention Time

In `CHAT_SETUP.sql`, change the expiry time:
```sql
-- Change from 2 hours to 4 hours:
expires_at TIMESTAMP WITH TIME ZONE DEFAULT (NOW() + INTERVAL '4 hours')
```

And in the cleanup function:
```sql
-- Change from 2 hours to 4 hours:
WHERE created_at < (NOW() - INTERVAL '4 hours');
```

---

## Step 7: Testing Checklist

- [ ] Supabase tables created successfully
- [ ] Chat button appears on tracking page
- [ ] Can open chat window
- [ ] Can send messages as customer
- [ ] Email notification received on first message
- [ ] Messages appear in admin panel
- [ ] Can respond as admin
- [ ] Customer receives admin responses in real-time
- [ ] Unread badges work correctly
- [ ] Can switch between different chat sessions
- [ ] Messages persist after page reload (within 2 hours)

---

## Troubleshooting

### Chat button doesn't appear
- Check browser console for errors
- Verify Supabase credentials in track.html
- Make sure the chat widget code is before `</body>` tag

### Messages not sending
- Check Supabase credentials are correct
- Verify tables were created properly
- Check browser console for errors
- Ensure Supabase RLS policies allow operations

### Email not received
- Verify Formspree endpoint is correct
- Check spam folder
- Verify email address in Formspree dashboard
- Check browser network tab for failed requests

### Admin panel not showing chats
- Check Supabase credentials in admin.html
- Verify chat tables exist in Supabase
- Check browser console for errors
- Ensure chat sessions are active (not expired)

### Real-time updates not working
- Check Supabase Realtime is enabled for the tables
- Verify browser WebSocket connection
- Check browser console for subscription errors
- Try refreshing the admin panel

---

## Database Schema

### chat_sessions
```
id              UUID (Primary Key)
tracking_number TEXT (Tracking ID)
session_id      TEXT (Unique session identifier)
visitor_id      TEXT (Optional browser ID)
is_active       BOOLEAN (Active status)
email_sent      BOOLEAN (Email notification sent)
created_at      TIMESTAMP (Session start time)
expires_at      TIMESTAMP (Session expiry time - 2 hours)
```

### chat_messages
```
id              UUID (Primary Key)
session_id      TEXT (Links to chat_sessions)
tracking_number TEXT (Tracking ID)
sender_type     TEXT ('customer' or 'admin')
sender_name     TEXT (Display name)
message_text    TEXT (Message content)
is_read         BOOLEAN (Read status)
created_at      TIMESTAMP (Message time)
```

---

## Security Notes

1. **Row Level Security (RLS)** is enabled on both tables
2. All operations are allowed through the anon key (for demo purposes)
3. In production, consider:
   - Implementing proper authentication for admin panel
   - Restricting RLS policies to authenticated users
   - Rate limiting message sending
   - Validating message content
   - Sanitizing user input

---

## Support

If you encounter issues:
1. Check this documentation first
2. Review browser console for errors
3. Check Supabase logs
4. Verify all credentials are correct
5. Ensure tables are created properly

---

## Files Modified

1. **track.html** - Added floating chat widget and real-time messaging
2. **admin.html** - Added chat panel and admin messaging interface
3. **CHAT_SETUP.sql** - Database schema for chat system

---

## Next Steps (Optional Enhancements)

- [ ] Add typing indicators
- [ ] Add file upload support
- [ ] Add emoji picker
- [ ] Add sound notifications
- [ ] Add desktop notifications
- [ ] Add chat transcript export
- [ ] Add automated responses
- [ ] Add chat analytics
- [ ] Add multi-admin support with names
- [ ] Add customer satisfaction ratings

Enjoy your new live chat system! 🎉
