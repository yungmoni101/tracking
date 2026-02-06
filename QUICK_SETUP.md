# ⚡ Quick Setup - Live Chat System

## 🚀 3 Steps to Get Started

### Step 1: Run SQL in Supabase (2 minutes)
1. Go to your [Supabase Dashboard](https://supabase.com/dashboard)
2. Select your project: `oezptlpmojaojibotsbs`
3. Click **SQL Editor** in the left menu
4. Click **New query**
5. Copy the entire contents of `CHAT_SETUP.sql`
6. Paste and click **Run**
7. You should see: "Success. No rows returned"

### Step 2: Test Customer Chat (1 minute)
1. Open a tracking page in your browser: `track.html?tracking=1Z2902E30419053424`
2. Look for the **blue chat button** in the bottom right corner 💬
3. Click it to open the chat window
4. Type a message and press Enter
5. ✅ **An email will be sent to you automatically** (check spam folder)

### Step 3: Test Admin Chat (1 minute)
1. Open `admin.html` in your browser
2. Click **💬 Live Chat** button in the top right
3. You should see your test chat session
4. Click on it to open the conversation
5. Type a reply and press Enter
6. ✅ **The customer will see your message in real-time!**

---

## What Was Added

### ✨ Customer Features (track.html)
- Floating chat button (bottom right)
- Chat window with tracking number display
- Real-time messaging
- Messages persist for 2 hours even after refresh
- Silent email notification to admin on first message

### 💼 Admin Features (admin.html)
- Live Chat button in header
- Sliding chat panel from right
- See all active chats with tracking numbers
- Unread message badges (red)
- Real-time message updates
- Switch between multiple chats
- Auto-refresh every 30 seconds

---

## 📋 Files Created/Modified

### New Files:
- `CHAT_SETUP.sql` - Database tables for chat system
- `CHAT_SYSTEM_GUIDE.md` - Complete documentation
- `QUICK_SETUP.md` - This file

### Modified Files:
- `track.html` - Added floating chat widget
- `admin.html` - Added live chat panel

---

## 🎨 Chat Appearance

### Customer Chat (track.html)
- Blue circular button with 💬 icon
- Modern chat window: 380x550px
- Tracking number shown in header
- Customer messages: Blue bubbles on right
- Admin messages: White bubbles on left

### Admin Chat (admin.html)
- Yellow "💬 Live Chat" button in header
- Right-side panel: 600px wide
- Session list at top
- Messages in middle
- Input at bottom
- Unread badges in red

---

## 🔔 Email Notifications

When a customer sends their **first message**, an email is sent to:
- **Formspree endpoint**: `https://formspree.io/f/xqedzwwe`
- **Contains**: Tracking number, first message, session ID

The email is sent **silently** - no loading spinner or confirmation shown to customer.

---

## ⏰ Message Retention

- Messages are stored for **2 hours**
- After 2 hours, sessions expire
- Old messages can be cleaned up by running:
  ```sql
  SELECT cleanup_expired_chats();
  ```

---

## 🐛 Troubleshooting

**Chat button doesn't appear?**
- Hard refresh the page (Ctrl+F5 or Cmd+Shift+R)
- Check browser console for errors

**Can't send messages?**
- Make sure you ran the SQL setup
- Check Supabase credentials are correct
- Verify your Supabase project is active

**Email not received?**
- Check spam folder
- Verify Formspree endpoint in track.html
- Check Formspree dashboard

**Admin panel doesn't show chats?**
- Make sure customer sent at least one message
- Hard refresh admin.html
- Check browser console for errors

---

## 🎯 Test Scenario

1. **Open track.html** in one browser tab
2. **Open admin.html** in another tab
3. **In track.html**: Click chat, send "Hello, where is my package?"
4. **Check your email**: You should receive notification
5. **In admin.html**: Click Live Chat, see the new chat session
6. **In admin.html**: Click the session, type "Hi! Let me check for you."
7. **In track.html**: See the admin reply appear instantly
8. **In track.html**: Reload the page, click chat - messages still there!

---

## 📞 Support

For detailed information, see `CHAT_SYSTEM_GUIDE.md`

For Supabase setup, see `SUPABASE_SETUP.md`

---

## ✅ Quick Checklist

- [ ] Ran SQL script in Supabase
- [ ] Saw chat button on track.html
- [ ] Sent test message as customer
- [ ] Received email notification
- [ ] Opened admin chat panel
- [ ] Saw customer message in admin
- [ ] Sent reply as admin
- [ ] Saw reply in customer chat
- [ ] Reloaded page - messages persisted

**All checked?** 🎉 You're ready to go!

---

## 🚀 Next Steps

Your live chat system is now ready! Customers can click the chat button on any tracking page and start chatting with you in real-time.

**Pro Tips:**
- Keep admin.html open in a tab to see new chats
- Check the Live Chat button badge for unread count
- Respond quickly for best customer experience
- Messages auto-delete after 2 hours to keep database clean

Enjoy your new chat system! 💬✨
