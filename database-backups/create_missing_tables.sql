-- ============================================================
-- SQL Script to create missing tables for prof_AI backup restore
-- Run this BEFORE restoring the backup file
-- Target: Neon database (neondb)
-- ============================================================

-- Enable pgcrypto extension for gen_random_uuid()
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- ============================================================
-- 1. CREATE SEQUENCES (required for auto-increment integer IDs)
-- ============================================================

CREATE SEQUENCE IF NOT EXISTS modules_id_seq;
CREATE SEQUENCE IF NOT EXISTS quiz_questions_id_seq;
CREATE SEQUENCE IF NOT EXISTS quiz_responses_id_seq;
CREATE SEQUENCE IF NOT EXISTS quizzes_id_seq;
CREATE SEQUENCE IF NOT EXISTS topics_id_seq;
CREATE SEQUENCE IF NOT EXISTS user_progress_id_seq;

-- ============================================================
-- 2. CREATE TABLES
-- ============================================================

-- Table: users (base table, must exist first for foreign keys)
CREATE TABLE IF NOT EXISTS "users" (
  "id" text NOT NULL DEFAULT (gen_random_uuid())::text,
  "username" text NOT NULL,
  "email" text NOT NULL,
  "password" text NOT NULL,
  "role" text NOT NULL DEFAULT 'student'::text,
  "student_type" text,
  "college_name" text,
  "degree" text,
  "school_class" text,
  "school_affiliation" text,
  "terms_accepted" boolean NOT NULL DEFAULT false,
  "created_at" timestamp without time zone DEFAULT now(),
  PRIMARY KEY ("id"),
  UNIQUE ("username"),
  UNIQUE ("email")
);

-- Table: courses
CREATE TABLE IF NOT EXISTS "courses" (
  "id" text NOT NULL DEFAULT (gen_random_uuid())::text,
  "title" text NOT NULL,
  "description" text,
  "level" text DEFAULT 'Beginner'::text,
  "teacher_id" text NOT NULL,
  "is_free" boolean NOT NULL DEFAULT false,
  "price" numeric DEFAULT 0,
  "currency" text DEFAULT 'INR'::text,
  "course_order" integer,
  "file_metadata" jsonb,
  "created_at" timestamp without time zone DEFAULT now(),
  "updated_at" timestamp without time zone DEFAULT now(),
  "created_by" character varying,
  "course_number" integer,
  PRIMARY KEY ("id")
);

-- Table: modules
CREATE TABLE IF NOT EXISTS "modules" (
  "id" integer NOT NULL DEFAULT nextval('modules_id_seq'::regclass),
  "course_id" text NOT NULL,
  "week" integer NOT NULL,
  "title" character varying(500) NOT NULL,
  "description" text,
  "learning_objectives" text[],
  "order_index" integer,
  "created_at" timestamp without time zone DEFAULT now(),
  PRIMARY KEY ("id")
);

-- Table: topics
CREATE TABLE IF NOT EXISTS "topics" (
  "id" integer NOT NULL DEFAULT nextval('topics_id_seq'::regclass),
  "module_id" integer NOT NULL,
  "title" character varying(500) NOT NULL,
  "content" text NOT NULL,
  "order_index" integer,
  "estimated_time" integer,
  "created_at" timestamp without time zone DEFAULT now(),
  PRIMARY KEY ("id")
);

-- Table: enrollments
CREATE TABLE IF NOT EXISTS "enrollments" (
  "id" text NOT NULL DEFAULT (gen_random_uuid())::text,
  "student_id" text NOT NULL,
  "course_id" text NOT NULL,
  "is_paid" boolean NOT NULL DEFAULT false,
  "enrolled_at" timestamp without time zone DEFAULT now(),
  PRIMARY KEY ("id")
);

-- Table: payments
CREATE TABLE IF NOT EXISTS "payments" (
  "id" text NOT NULL DEFAULT (gen_random_uuid())::text,
  "student_id" text NOT NULL,
  "course_id" text NOT NULL,
  "enrollment_id" text,
  "order_id" text NOT NULL,
  "amount" numeric NOT NULL,
  "currency" text DEFAULT 'INR'::text,
  "status" text NOT NULL DEFAULT 'pending'::text,
  "payment_method" text,
  "transaction_id" text,
  "tracking_id" text,
  "bank_ref_no" text,
  "ccavenue_response" jsonb,
  "created_at" timestamp without time zone DEFAULT now(),
  "updated_at" timestamp without time zone DEFAULT now(),
  PRIMARY KEY ("id")
);

-- Table: quizzes
CREATE TABLE IF NOT EXISTS "quizzes" (
  "id" integer NOT NULL DEFAULT nextval('quizzes_id_seq'::regclass),
  "quiz_id" character varying(100) NOT NULL,
  "course_id" text NOT NULL,
  "module_id" integer,
  "title" character varying(500) NOT NULL,
  "description" text,
  "quiz_type" character varying(50) DEFAULT 'module'::character varying,
  "passing_score" integer DEFAULT 70,
  "time_limit" integer,
  "created_at" timestamp without time zone DEFAULT now(),
  PRIMARY KEY ("id")
);

-- Table: quiz_questions
CREATE TABLE IF NOT EXISTS "quiz_questions" (
  "id" integer NOT NULL DEFAULT nextval('quiz_questions_id_seq'::regclass),
  "quiz_id" character varying(100) NOT NULL,
  "question_number" integer NOT NULL,
  "question_text" text NOT NULL,
  "options" jsonb NOT NULL,
  "correct_answer" character(1) NOT NULL,
  "explanation" text,
  "difficulty" character varying(20),
  "created_at" timestamp without time zone DEFAULT now(),
  PRIMARY KEY ("id")
);

-- Table: quiz_responses
CREATE TABLE IF NOT EXISTS "quiz_responses" (
  "id" integer NOT NULL DEFAULT nextval('quiz_responses_id_seq'::regclass),
  "quiz_id" character varying(100) NOT NULL,
  "user_id" text NOT NULL,
  "answers" jsonb NOT NULL,
  "score" integer,
  "total_questions" integer,
  "correct_answers" integer,
  "submitted_at" timestamp without time zone DEFAULT now(),
  "time_taken" integer,
  PRIMARY KEY ("id")
);

-- Table: session (for express-session)
CREATE TABLE IF NOT EXISTS "session" (
  "sid" character varying NOT NULL,
  "sess" json NOT NULL,
  "expire" timestamp without time zone NOT NULL,
  PRIMARY KEY ("sid")
);

-- Table: user_progress
CREATE TABLE IF NOT EXISTS "user_progress" (
  "id" integer NOT NULL DEFAULT nextval('user_progress_id_seq'::regclass),
  "user_id" text NOT NULL,
  "course_id" text NOT NULL,
  "module_id" integer,
  "topic_id" integer,
  "status" character varying(50) DEFAULT 'not_started'::character varying,
  "progress_percentage" integer DEFAULT 0,
  "last_accessed" timestamp without time zone DEFAULT now(),
  "completion_date" timestamp without time zone,
  PRIMARY KEY ("id")
);

-- Table: course_id_mapping
CREATE TABLE IF NOT EXISTS "course_id_mapping" (
  "id" text NOT NULL DEFAULT (gen_random_uuid())::text,
  "new_course_id" text NOT NULL,
  "old_course_id" text NOT NULL,
  "description" text,
  "created_at" timestamp without time zone DEFAULT now(),
  "updated_at" timestamp without time zone DEFAULT now(),
  PRIMARY KEY ("id"),
  UNIQUE ("new_course_id")
);

-- Table: course_images
CREATE TABLE IF NOT EXISTS "course_images" (
  "id" character varying NOT NULL DEFAULT gen_random_uuid(),
  "course_id" text NOT NULL,
  "image_url" text NOT NULL,
  "created_at" timestamp without time zone DEFAULT now(),
  "updated_at" timestamp without time zone DEFAULT now(),
  "course_name" text,
  PRIMARY KEY ("id"),
  UNIQUE ("course_id")
);

-- Table: course_pricing
CREATE TABLE IF NOT EXISTS "course_pricing" (
  "id" text NOT NULL DEFAULT (gen_random_uuid())::text,
  "course_id" text NOT NULL,
  "price" numeric NOT NULL DEFAULT 0.00,
  "currency" text NOT NULL DEFAULT 'INR'::text,
  "is_free" boolean NOT NULL DEFAULT false,
  "display_order" integer,
  "created_at" timestamp without time zone DEFAULT now(),
  "updated_at" timestamp without time zone DEFAULT now(),
  "course_name" text,
  PRIMARY KEY ("id"),
  UNIQUE ("course_id")
);

-- Table: user_purchases
CREATE TABLE IF NOT EXISTS "user_purchases" (
  "id" text NOT NULL DEFAULT (gen_random_uuid())::text,
  "user_id" text NOT NULL,
  "course_id" text NOT NULL,
  "payment_id" text,
  "amount" numeric NOT NULL,
  "currency" text NOT NULL DEFAULT 'INR'::text,
  "status" text NOT NULL DEFAULT 'pending'::text,
  "payment_method" text DEFAULT 'ccavenue'::text,
  "purchased_at" timestamp without time zone DEFAULT now(),
  "expires_at" timestamp without time zone,
  PRIMARY KEY ("id")
);

-- Table: payment_transactions
CREATE TABLE IF NOT EXISTS "payment_transactions" (
  "id" text NOT NULL DEFAULT (gen_random_uuid())::text,
  "user_id" text NOT NULL,
  "course_id" text NOT NULL,
  "order_id" text NOT NULL,
  "ccavenue_order_id" text,
  "amount" numeric NOT NULL,
  "currency" text NOT NULL DEFAULT 'INR'::text,
  "status" text NOT NULL DEFAULT 'initiated'::text,
  "payment_response" text,
  "created_at" timestamp without time zone DEFAULT now(),
  "updated_at" timestamp without time zone DEFAULT now(),
  PRIMARY KEY ("id"),
  UNIQUE ("order_id")
);

-- Table: course_progress
CREATE TABLE IF NOT EXISTS "course_progress" (
  "id" text NOT NULL DEFAULT (gen_random_uuid())::text,
  "user_id" text NOT NULL,
  "course_key" text NOT NULL,
  "course_version" text NOT NULL,
  "progress" jsonb NOT NULL,
  "created_at" timestamp without time zone DEFAULT now(),
  "updated_at" timestamp without time zone DEFAULT now(),
  PRIMARY KEY ("id"),
  UNIQUE ("user_id", "course_key", "course_version")
);

-- Table: blogs
CREATE TABLE IF NOT EXISTS "blogs" (
  "id" text NOT NULL DEFAULT (gen_random_uuid())::text,
  "slug" text NOT NULL,
  "title" text NOT NULL,
  "excerpt" text,
  "content" text NOT NULL,
  "image_url" text,
  "author_id" text,
  "published" boolean NOT NULL DEFAULT true,
  "created_at" timestamp without time zone DEFAULT now(),
  "updated_at" timestamp without time zone DEFAULT now(),
  PRIMARY KEY ("id"),
  UNIQUE ("slug")
);

-- Table: api_access_requests
CREATE TABLE IF NOT EXISTS "api_access_requests" (
  "id" text NOT NULL DEFAULT (gen_random_uuid())::text,
  "first_name" text NOT NULL,
  "last_name" text NOT NULL,
  "email" text NOT NULL,
  "phone" text NOT NULL,
  "company" text NOT NULL,
  "job_title" text NOT NULL,
  "use_case" text,
  "status" text NOT NULL DEFAULT 'pending',
  "created_at" timestamp without time zone DEFAULT now(),
  "updated_at" timestamp without time zone DEFAULT now(),
  PRIMARY KEY ("id")
);

-- ============================================================
-- 3. CREATE INDEXES
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_session_expire ON session(expire);
CREATE INDEX IF NOT EXISTS idx_modules_course_id ON modules(course_id);
CREATE INDEX IF NOT EXISTS idx_topics_module_id ON topics(module_id);
CREATE INDEX IF NOT EXISTS idx_enrollments_student_id ON enrollments(student_id);
CREATE INDEX IF NOT EXISTS idx_enrollments_course_id ON enrollments(course_id);
CREATE INDEX IF NOT EXISTS idx_payments_student_id ON payments(student_id);
CREATE INDEX IF NOT EXISTS idx_payments_order_id ON payments(order_id);
CREATE INDEX IF NOT EXISTS idx_quizzes_course_id ON quizzes(course_id);
CREATE INDEX IF NOT EXISTS idx_quizzes_quiz_id ON quizzes(quiz_id);
CREATE INDEX IF NOT EXISTS idx_quiz_questions_quiz_id ON quiz_questions(quiz_id);
CREATE INDEX IF NOT EXISTS idx_quiz_responses_quiz_id ON quiz_responses(quiz_id);
CREATE INDEX IF NOT EXISTS idx_quiz_responses_user_id ON quiz_responses(user_id);
CREATE INDEX IF NOT EXISTS idx_user_progress_user_id ON user_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_user_progress_course_id ON user_progress(course_id);
CREATE INDEX IF NOT EXISTS idx_user_purchases_user_id ON user_purchases(user_id);
CREATE INDEX IF NOT EXISTS idx_user_purchases_course_id ON user_purchases(course_id);
CREATE INDEX IF NOT EXISTS idx_payment_transactions_user_id ON payment_transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_payment_transactions_order_id ON payment_transactions(order_id);
CREATE INDEX IF NOT EXISTS idx_course_pricing_course_id ON course_pricing(course_id);
CREATE INDEX IF NOT EXISTS idx_course_pricing_display_order ON course_pricing(display_order);
CREATE INDEX IF NOT EXISTS idx_course_images_course_id ON course_images(course_id);
CREATE INDEX IF NOT EXISTS idx_course_id_mapping_new_id ON course_id_mapping(new_course_id);
CREATE INDEX IF NOT EXISTS idx_course_id_mapping_old_id ON course_id_mapping(old_course_id);
CREATE INDEX IF NOT EXISTS idx_course_progress_user_id ON course_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_course_progress_course_key ON course_progress(course_key);
CREATE INDEX IF NOT EXISTS idx_api_access_requests_email ON api_access_requests(email);
CREATE INDEX IF NOT EXISTS idx_api_access_requests_status ON api_access_requests(status);
CREATE INDEX IF NOT EXISTS idx_blogs_slug ON blogs(slug);
CREATE INDEX IF NOT EXISTS idx_blogs_published_created_at ON blogs(published, created_at);

-- ============================================================
-- Done! Now you can restore the backup file.
-- ============================================================
