/*
  # Create poems table and security policies

  1. New Tables
    - `poems`
      - `id` (uuid, primary key)
      - `title` (text)
      - `author` (text)
      - `content` (text)
      - `user_id` (uuid, references auth.users)
      - `created_at` (timestamp)

  2. Security
    - Enable RLS on `poems` table
    - Add policies for:
      - Public read access to all poems
      - Authenticated users can create poems
      - Users can only update/delete their own poems
*/

CREATE TABLE IF NOT EXISTS poems (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  author text NOT NULL,
  content text NOT NULL,
  user_id uuid REFERENCES auth.users NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE poems ENABLE ROW LEVEL SECURITY;

DO $$ 
BEGIN
  -- Drop existing policies if they exist
  DROP POLICY IF EXISTS "Anyone can read poems" ON poems;
  DROP POLICY IF EXISTS "Authenticated users can create poems" ON poems;
  DROP POLICY IF EXISTS "Users can update their own poems" ON poems;
  DROP POLICY IF EXISTS "Users can delete their own poems" ON poems;
  
  -- Create new policies
  CREATE POLICY "Anyone can read poems"
    ON poems
    FOR SELECT
    USING (true);

  CREATE POLICY "Authenticated users can create poems"
    ON poems
    FOR INSERT
    TO authenticated
    WITH CHECK (true);

  CREATE POLICY "Users can update their own poems"
    ON poems
    FOR UPDATE
    TO authenticated
    USING (auth.uid() = user_id);

  CREATE POLICY "Users can delete their own poems"
    ON poems
    FOR DELETE
    TO authenticated
    USING (auth.uid() = user_id);
END $$;