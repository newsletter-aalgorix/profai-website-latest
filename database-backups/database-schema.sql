--
-- PostgreSQL Database Schema for ProfAI Website
-- Generated: 2026-04-06
-- Source: Neon PostgreSQL (neondb)
--
-- Usage: psql -f database-schema.sql <connection_string>
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: api_access_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.api_access_requests (
    id text DEFAULT (gen_random_uuid())::text NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL,
    email text NOT NULL,
    phone text NOT NULL,
    company text NOT NULL,
    job_title text NOT NULL,
    use_case text,
    status text DEFAULT 'pending'::text NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


--
-- Name: blogs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.blogs (
    id text DEFAULT (gen_random_uuid())::text NOT NULL,
    slug text NOT NULL,
    title text NOT NULL,
    excerpt text,
    content text NOT NULL,
    image_url text,
    author_id text,
    published boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


--
-- Name: course_id_mapping; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.course_id_mapping (
    id text DEFAULT (gen_random_uuid())::text NOT NULL,
    new_course_id text NOT NULL,
    old_course_id text NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


--
-- Name: course_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.course_images (
    id character varying DEFAULT gen_random_uuid() NOT NULL,
    course_id text NOT NULL,
    image_url text NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    course_name text
);


--
-- Name: course_pricing; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.course_pricing (
    id text DEFAULT (gen_random_uuid())::text NOT NULL,
    course_id text NOT NULL,
    price numeric DEFAULT 0.00 NOT NULL,
    currency text DEFAULT 'INR'::text NOT NULL,
    is_free boolean DEFAULT false NOT NULL,
    display_order integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    course_name text
);


--
-- Name: course_progress; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.course_progress (
    id text DEFAULT (gen_random_uuid())::text NOT NULL,
    user_id text NOT NULL,
    course_key text NOT NULL,
    course_version text NOT NULL,
    progress jsonb NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


--
-- Name: courses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.courses (
    id text DEFAULT (gen_random_uuid())::text NOT NULL,
    title text NOT NULL,
    description text,
    level text DEFAULT 'Beginner'::text,
    teacher_id text NOT NULL,
    is_free boolean DEFAULT false NOT NULL,
    price numeric DEFAULT 0,
    currency text DEFAULT 'INR'::text,
    course_order integer,
    file_metadata jsonb,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    created_by character varying,
    course_number integer,
    country text
);


--
-- Name: enrollments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.enrollments (
    id text DEFAULT (gen_random_uuid())::text NOT NULL,
    student_id text NOT NULL,
    course_id text NOT NULL,
    is_paid boolean DEFAULT false NOT NULL,
    enrolled_at timestamp without time zone DEFAULT now()
);


--
-- Name: modules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.modules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: modules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.modules (
    id integer DEFAULT nextval('public.modules_id_seq'::regclass) NOT NULL,
    course_id text NOT NULL,
    week integer NOT NULL,
    title character varying(500) NOT NULL,
    description text,
    learning_objectives text[],
    order_index integer,
    created_at timestamp without time zone DEFAULT now()
);


--
-- Name: payment_transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment_transactions (
    id text DEFAULT (gen_random_uuid())::text NOT NULL,
    user_id text NOT NULL,
    course_id text NOT NULL,
    order_id text NOT NULL,
    ccavenue_order_id text,
    amount numeric NOT NULL,
    currency text DEFAULT 'INR'::text NOT NULL,
    status text DEFAULT 'initiated'::text NOT NULL,
    payment_response text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


--
-- Name: payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payments (
    id text DEFAULT (gen_random_uuid())::text NOT NULL,
    student_id text NOT NULL,
    course_id text NOT NULL,
    enrollment_id text,
    order_id text NOT NULL,
    amount numeric NOT NULL,
    currency text DEFAULT 'INR'::text,
    status text DEFAULT 'pending'::text NOT NULL,
    payment_method text,
    transaction_id text,
    tracking_id text,
    bank_ref_no text,
    ccavenue_response jsonb,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


--
-- Name: quiz_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.quiz_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quiz_questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quiz_questions (
    id integer DEFAULT nextval('public.quiz_questions_id_seq'::regclass) NOT NULL,
    quiz_id character varying(100) NOT NULL,
    question_number integer NOT NULL,
    question_text text NOT NULL,
    options jsonb NOT NULL,
    correct_answer character(1) NOT NULL,
    explanation text,
    difficulty character varying(20),
    created_at timestamp without time zone DEFAULT now()
);


--
-- Name: quiz_responses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.quiz_responses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quiz_responses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quiz_responses (
    id integer DEFAULT nextval('public.quiz_responses_id_seq'::regclass) NOT NULL,
    quiz_id character varying(100) NOT NULL,
    user_id text NOT NULL,
    answers jsonb NOT NULL,
    score integer,
    total_questions integer,
    correct_answers integer,
    submitted_at timestamp without time zone DEFAULT now(),
    time_taken integer
);


--
-- Name: quizzes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.quizzes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quizzes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quizzes (
    id integer DEFAULT nextval('public.quizzes_id_seq'::regclass) NOT NULL,
    quiz_id character varying(100) NOT NULL,
    course_id text NOT NULL,
    module_id integer,
    title character varying(500) NOT NULL,
    description text,
    quiz_type character varying(50) DEFAULT 'module'::character varying,
    passing_score integer DEFAULT 70,
    time_limit integer,
    created_at timestamp without time zone DEFAULT now()
);


--
-- Name: session; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.session (
    sid character varying NOT NULL,
    sess json NOT NULL,
    expire timestamp without time zone NOT NULL
);


--
-- Name: topics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.topics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: topics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.topics (
    id integer DEFAULT nextval('public.topics_id_seq'::regclass) NOT NULL,
    module_id integer NOT NULL,
    title character varying(500) NOT NULL,
    content text NOT NULL,
    order_index integer,
    estimated_time integer,
    created_at timestamp without time zone DEFAULT now()
);


--
-- Name: user_progress_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_progress_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_progress; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_progress (
    id integer DEFAULT nextval('public.user_progress_id_seq'::regclass) NOT NULL,
    user_id text NOT NULL,
    course_id text NOT NULL,
    module_id integer,
    topic_id integer,
    status character varying(50) DEFAULT 'not_started'::character varying,
    progress_percentage integer DEFAULT 0,
    last_accessed timestamp without time zone DEFAULT now(),
    completion_date timestamp without time zone
);


--
-- Name: user_purchases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_purchases (
    id text DEFAULT (gen_random_uuid())::text NOT NULL,
    user_id text NOT NULL,
    course_id text NOT NULL,
    payment_id text,
    amount numeric NOT NULL,
    currency text DEFAULT 'INR'::text NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    payment_method text DEFAULT 'ccavenue'::text,
    purchased_at timestamp without time zone DEFAULT now(),
    expires_at timestamp without time zone
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id text DEFAULT (gen_random_uuid())::text NOT NULL,
    username text NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    role text DEFAULT 'student'::text NOT NULL,
    student_type text,
    college_name text,
    degree text,
    school_class text,
    school_affiliation text,
    terms_accepted boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    institution text,
    subject text,
    experience text
);


--
-- Name: api_access_requests api_access_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_access_requests
    ADD CONSTRAINT api_access_requests_pkey PRIMARY KEY (id);


--
-- Name: blogs blogs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blogs
    ADD CONSTRAINT blogs_pkey PRIMARY KEY (id);


--
-- Name: blogs blogs_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blogs
    ADD CONSTRAINT blogs_slug_key UNIQUE (slug);


--
-- Name: course_id_mapping course_id_mapping_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_id_mapping
    ADD CONSTRAINT course_id_mapping_pkey PRIMARY KEY (id);


--
-- Name: course_images course_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_images
    ADD CONSTRAINT course_images_pkey PRIMARY KEY (id);


--
-- Name: course_pricing course_pricing_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_pricing
    ADD CONSTRAINT course_pricing_pkey PRIMARY KEY (id);


--
-- Name: course_progress course_progress_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_progress
    ADD CONSTRAINT course_progress_pkey PRIMARY KEY (id);


--
-- Name: course_progress course_progress_user_id_course_key_course_version_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_progress
    ADD CONSTRAINT course_progress_user_id_course_key_course_version_key UNIQUE (user_id, course_key, course_version);


--
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
-- Name: enrollments enrollments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.enrollments
    ADD CONSTRAINT enrollments_pkey PRIMARY KEY (id);


--
-- Name: modules modules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.modules
    ADD CONSTRAINT modules_pkey PRIMARY KEY (id);


--
-- Name: payment_transactions payment_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_transactions
    ADD CONSTRAINT payment_transactions_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: quiz_questions quiz_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quiz_questions
    ADD CONSTRAINT quiz_questions_pkey PRIMARY KEY (id);


--
-- Name: quiz_responses quiz_responses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quiz_responses
    ADD CONSTRAINT quiz_responses_pkey PRIMARY KEY (id);


--
-- Name: quizzes quizzes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quizzes
    ADD CONSTRAINT quizzes_pkey PRIMARY KEY (id);


--
-- Name: session session_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session
    ADD CONSTRAINT session_pkey PRIMARY KEY (sid);


--
-- Name: topics topics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.topics
    ADD CONSTRAINT topics_pkey PRIMARY KEY (id);


--
-- Name: user_progress user_progress_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_progress
    ADD CONSTRAINT user_progress_pkey PRIMARY KEY (id);


--
-- Name: user_purchases user_purchases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_purchases
    ADD CONSTRAINT user_purchases_pkey PRIMARY KEY (id);


--
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_unique UNIQUE (username);


--
-- Name: idx_api_access_requests_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_api_access_requests_created_at ON public.api_access_requests USING btree (created_at);


--
-- Name: idx_api_access_requests_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_api_access_requests_email ON public.api_access_requests USING btree (email);


--
-- Name: idx_api_access_requests_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_api_access_requests_status ON public.api_access_requests USING btree (status);


--
-- Name: idx_blogs_published_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_blogs_published_created_at ON public.blogs USING btree (published, created_at);


--
-- Name: idx_blogs_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_blogs_slug ON public.blogs USING btree (slug);


--
-- Name: idx_course_id_mapping_new_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_course_id_mapping_new_id ON public.course_id_mapping USING btree (new_course_id);


--
-- Name: idx_course_id_mapping_old_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_course_id_mapping_old_id ON public.course_id_mapping USING btree (old_course_id);


--
-- Name: idx_course_images_course_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_course_images_course_id ON public.course_images USING btree (course_id);


--
-- Name: idx_course_pricing_course_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_course_pricing_course_id ON public.course_pricing USING btree (course_id);


--
-- Name: idx_course_pricing_display_order; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_course_pricing_display_order ON public.course_pricing USING btree (display_order);


--
-- Name: idx_course_progress_course_key; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_course_progress_course_key ON public.course_progress USING btree (course_key);


--
-- Name: idx_course_progress_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_course_progress_user_id ON public.course_progress USING btree (user_id);


--
-- Name: idx_enrollments_course_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_enrollments_course_id ON public.enrollments USING btree (course_id);


--
-- Name: idx_enrollments_student_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_enrollments_student_id ON public.enrollments USING btree (student_id);


--
-- Name: idx_modules_course_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_modules_course_id ON public.modules USING btree (course_id);


--
-- Name: idx_payment_transactions_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_payment_transactions_order_id ON public.payment_transactions USING btree (order_id);


--
-- Name: idx_payment_transactions_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_payment_transactions_user_id ON public.payment_transactions USING btree (user_id);


--
-- Name: idx_payments_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_payments_order_id ON public.payments USING btree (order_id);


--
-- Name: idx_payments_student_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_payments_student_id ON public.payments USING btree (student_id);


--
-- Name: idx_quiz_questions_quiz_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quiz_questions_quiz_id ON public.quiz_questions USING btree (quiz_id);


--
-- Name: idx_quiz_responses_quiz_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quiz_responses_quiz_id ON public.quiz_responses USING btree (quiz_id);


--
-- Name: idx_quiz_responses_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quiz_responses_user_id ON public.quiz_responses USING btree (user_id);


--
-- Name: idx_quizzes_course_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quizzes_course_id ON public.quizzes USING btree (course_id);


--
-- Name: idx_quizzes_quiz_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quizzes_quiz_id ON public.quizzes USING btree (quiz_id);


--
-- Name: idx_session_expire; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_session_expire ON public.session USING btree (expire);


--
-- Name: idx_topics_module_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_topics_module_id ON public.topics USING btree (module_id);


--
-- Name: idx_user_purchases_course_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_purchases_course_id ON public.user_purchases USING btree (course_id);


--
-- Name: idx_user_purchases_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_purchases_user_id ON public.user_purchases USING btree (user_id);


--
-- PostgreSQL database dump complete
--
