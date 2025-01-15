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

-- Allow public read access
CREATE POLICY "Anyone can read poems"
  ON poems
  FOR SELECT
  USING (true);

-- Allow authenticated users to create poems
CREATE POLICY "Authenticated users can create poems"
  ON poems
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Allow users to update their own poems
CREATE POLICY "Users can update their own poems"
  ON poems
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id);

-- Allow users to delete their own poems
CREATE POLICY "Users can delete their own poems"
  ON poems
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);