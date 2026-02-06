-- AeroTrack Chat System Tables
-- Run this in your Supabase SQL Editor

-- Table 1: chat_sessions
CREATE TABLE chat_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tracking_number TEXT NOT NULL,
    session_id TEXT UNIQUE NOT NULL,
    visitor_id TEXT,
    is_active BOOLEAN DEFAULT true,
    email_sent BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE DEFAULT (NOW() + INTERVAL '2 hours')
);

-- Table 2: chat_messages
CREATE TABLE chat_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id TEXT REFERENCES chat_sessions(session_id) ON DELETE CASCADE,
    tracking_number TEXT NOT NULL,
    sender_type TEXT NOT NULL CHECK (sender_type IN ('customer', 'admin')),
    sender_name TEXT,
    message_text TEXT NOT NULL,
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE chat_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;

-- Create policies to allow all operations
CREATE POLICY "Allow all operations on chat_sessions" ON chat_sessions
FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Allow all operations on chat_messages" ON chat_messages
FOR ALL USING (true) WITH CHECK (true);

-- Create indexes for better performance
CREATE INDEX chat_sessions_tracking_number_idx ON chat_sessions(tracking_number);
CREATE INDEX chat_sessions_expires_at_idx ON chat_sessions(expires_at);
CREATE INDEX chat_sessions_is_active_idx ON chat_sessions(is_active);
CREATE INDEX chat_messages_session_id_idx ON chat_messages(session_id);
CREATE INDEX chat_messages_tracking_number_idx ON chat_messages(tracking_number);
CREATE INDEX chat_messages_created_at_idx ON chat_messages(created_at);
CREATE INDEX chat_messages_sender_type_idx ON chat_messages(sender_type);

-- Function to clean up expired chats (run this manually or set up a cron job)
CREATE OR REPLACE FUNCTION cleanup_expired_chats()
RETURNS void AS $$
BEGIN
    -- Mark sessions as inactive if expired
    UPDATE chat_sessions 
    SET is_active = false 
    WHERE expires_at < NOW() AND is_active = true;
    
    -- Delete messages older than 2 hours
    DELETE FROM chat_messages 
    WHERE created_at < (NOW() - INTERVAL '2 hours');
    
    -- Delete expired sessions (optional - keeps history)
    -- DELETE FROM chat_sessions WHERE expires_at < NOW();
END;
$$ LANGUAGE plpgsql;

-- You can manually run the cleanup with:
-- SELECT cleanup_expired_chats();

-- Or set up a Supabase Edge Function or cron job to run it periodically
