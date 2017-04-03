--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: task; Type: TABLE; Schema: public; Owner: lbaw1614; Tablespace: 
--

CREATE TABLE task (
    id integer NOT NULL,
    name character(128)[] NOT NULL,
    description character(512)[],
    deadline date,
    creator_id integer NOT NULL,
    assigned_id integer,
    completer_id integer,
    project_id integer NOT NULL
);


ALTER TABLE task OWNER TO lbaw1614;

--
-- Name: Task_id_seq; Type: SEQUENCE; Schema: public; Owner: lbaw1614
--

CREATE SEQUENCE "Task_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "Task_id_seq" OWNER TO lbaw1614;

--
-- Name: Task_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lbaw1614
--

ALTER SEQUENCE "Task_id_seq" OWNED BY task.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: lbaw1614; Tablespace: 
--

CREATE TABLE "user" (
    id integer NOT NULL,
    name character(128)[] NOT NULL,
    username character(32)[],
    email character(128)[] NOT NULL,
    password character(64)[] NOT NULL,
    phone_number character(32)[],
    photo_path character(256)[],
    birth_date date,
    country character(64)[],
    city character(64)[]
);


ALTER TABLE "user" OWNER TO lbaw1614;

--
-- Name: User_id_seq; Type: SEQUENCE; Schema: public; Owner: lbaw1614
--

CREATE SEQUENCE "User_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "User_id_seq" OWNER TO lbaw1614;

--
-- Name: User_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lbaw1614
--

ALTER SEQUENCE "User_id_seq" OWNED BY "user".id;


--
-- Name: comment; Type: TABLE; Schema: public; Owner: lbaw1614; Tablespace: 
--

CREATE TABLE comment (
    id integer NOT NULL,
    creation_date date NOT NULL,
    content character(512)[] NOT NULL,
    id_user integer NOT NULL,
    id_task integer NOT NULL
);


ALTER TABLE comment OWNER TO lbaw1614;

--
-- Name: comment_id_seq; Type: SEQUENCE; Schema: public; Owner: lbaw1614
--

CREATE SEQUENCE comment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comment_id_seq OWNER TO lbaw1614;

--
-- Name: comment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lbaw1614
--

ALTER SEQUENCE comment_id_seq OWNED BY comment.id;


--
-- Name: comment_like; Type: TABLE; Schema: public; Owner: lbaw1614; Tablespace: 
--

CREATE TABLE comment_like (
    id_comment integer NOT NULL,
    id_user integer NOT NULL
);


ALTER TABLE comment_like OWNER TO lbaw1614;

--
-- Name: file; Type: TABLE; Schema: public; Owner: lbaw1614; Tablespace: 
--

CREATE TABLE file (
    id integer NOT NULL,
    upload_date date NOT NULL,
    uploader_id integer NOT NULL,
    project_id integer NOT NULL,
    name character(64)[] NOT NULL,
    path character(64)[] NOT NULL
);


ALTER TABLE file OWNER TO lbaw1614;

--
-- Name: file_id_seq; Type: SEQUENCE; Schema: public; Owner: lbaw1614
--

CREATE SEQUENCE file_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE file_id_seq OWNER TO lbaw1614;

--
-- Name: file_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lbaw1614
--

ALTER SEQUENCE file_id_seq OWNED BY file.id;


--
-- Name: file_meeting; Type: TABLE; Schema: public; Owner: lbaw1614; Tablespace: 
--

CREATE TABLE file_meeting (
    file_id integer NOT NULL,
    tag_id integer NOT NULL
);


ALTER TABLE file_meeting OWNER TO lbaw1614;

--
-- Name: file_tag; Type: TABLE; Schema: public; Owner: lbaw1614; Tablespace: 
--

CREATE TABLE file_tag (
    id_tag integer NOT NULL,
    id_file integer NOT NULL
);


ALTER TABLE file_tag OWNER TO lbaw1614;

--
-- Name: forum_post; Type: TABLE; Schema: public; Owner: lbaw1614; Tablespace: 
--

CREATE TABLE forum_post (
    id integer NOT NULL,
    title character(128)[] NOT NULL,
    creation_date date NOT NULL,
    content character(512)[] NOT NULL,
    id_project integer NOT NULL
);


ALTER TABLE forum_post OWNER TO lbaw1614;

--
-- Name: forum_post_id_seq; Type: SEQUENCE; Schema: public; Owner: lbaw1614
--

CREATE SEQUENCE forum_post_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE forum_post_id_seq OWNER TO lbaw1614;

--
-- Name: forum_post_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lbaw1614
--

ALTER SEQUENCE forum_post_id_seq OWNED BY forum_post.id;


--
-- Name: forum_post_like; Type: TABLE; Schema: public; Owner: lbaw1614; Tablespace: 
--

CREATE TABLE forum_post_like (
    id_post integer NOT NULL,
    id_user integer NOT NULL
);


ALTER TABLE forum_post_like OWNER TO lbaw1614;

--
-- Name: forum_reply; Type: TABLE; Schema: public; Owner: lbaw1614; Tablespace: 
--

CREATE TABLE forum_reply (
    id integer NOT NULL,
    creation_date date NOT NULL,
    content character(512)[] NOT NULL,
    post_id integer NOT NULL
);


ALTER TABLE forum_reply OWNER TO lbaw1614;

--
-- Name: forum_reply_id_seq; Type: SEQUENCE; Schema: public; Owner: lbaw1614
--

CREATE SEQUENCE forum_reply_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE forum_reply_id_seq OWNER TO lbaw1614;

--
-- Name: forum_reply_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lbaw1614
--

ALTER SEQUENCE forum_reply_id_seq OWNED BY forum_reply.id;


--
-- Name: forum_reply_like; Type: TABLE; Schema: public; Owner: lbaw1614; Tablespace: 
--

CREATE TABLE forum_reply_like (
    reply_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE forum_reply_like OWNER TO lbaw1614;

--
-- Name: meeting; Type: TABLE; Schema: public; Owner: lbaw1614; Tablespace: 
--

CREATE TABLE meeting (
    id integer NOT NULL,
    name character(64)[] NOT NULL,
    date date NOT NULL,
    duration integer,
    description character(512)[],
    id_creator integer NOT NULL,
    id_project integer NOT NULL
);


ALTER TABLE meeting OWNER TO lbaw1614;

--
-- Name: project; Type: TABLE; Schema: public; Owner: lbaw1614; Tablespace: 
--

CREATE TABLE project (
    id integer NOT NULL,
    name character(64)[] NOT NULL,
    description character(512)[]
);


ALTER TABLE project OWNER TO lbaw1614;

--
-- Name: project_id_seq; Type: SEQUENCE; Schema: public; Owner: lbaw1614
--

CREATE SEQUENCE project_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE project_id_seq OWNER TO lbaw1614;

--
-- Name: project_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lbaw1614
--

ALTER SEQUENCE project_id_seq OWNED BY project.id;


--
-- Name: tag; Type: TABLE; Schema: public; Owner: lbaw1614; Tablespace: 
--

CREATE TABLE tag (
    id integer NOT NULL,
    name character(32)[] NOT NULL
);


ALTER TABLE tag OWNER TO lbaw1614;

--
-- Name: tag_id_seq; Type: SEQUENCE; Schema: public; Owner: lbaw1614
--

CREATE SEQUENCE tag_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tag_id_seq OWNER TO lbaw1614;

--
-- Name: tag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lbaw1614
--

ALTER SEQUENCE tag_id_seq OWNED BY tag.id;


--
-- Name: task_tag; Type: TABLE; Schema: public; Owner: lbaw1614; Tablespace: 
--

CREATE TABLE task_tag (
    task_id integer NOT NULL,
    tag_id integer NOT NULL
);


ALTER TABLE task_tag OWNER TO lbaw1614;

--
-- Name: user_meeting; Type: TABLE; Schema: public; Owner: lbaw1614; Tablespace: 
--

CREATE TABLE user_meeting (
    meeting_id integer,
    user_id integer
);


ALTER TABLE user_meeting OWNER TO lbaw1614;

--
-- Name: user_project; Type: TABLE; Schema: public; Owner: lbaw1614; Tablespace: 
--

CREATE TABLE user_project (
    id_user integer NOT NULL,
    id_project integer NOT NULL,
    is_coordinator boolean NOT NULL
);


ALTER TABLE user_project OWNER TO lbaw1614;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY comment ALTER COLUMN id SET DEFAULT nextval('comment_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY file ALTER COLUMN id SET DEFAULT nextval('file_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY forum_post ALTER COLUMN id SET DEFAULT nextval('forum_post_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY forum_reply ALTER COLUMN id SET DEFAULT nextval('forum_reply_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY project ALTER COLUMN id SET DEFAULT nextval('project_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY tag ALTER COLUMN id SET DEFAULT nextval('tag_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY task ALTER COLUMN id SET DEFAULT nextval('"Task_id_seq"'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY "user" ALTER COLUMN id SET DEFAULT nextval('"User_id_seq"'::regclass);


--
-- Name: Task_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1614
--

SELECT pg_catalog.setval('"Task_id_seq"', 1, false);


--
-- Name: User_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1614
--

SELECT pg_catalog.setval('"User_id_seq"', 1, false);


--
-- Data for Name: comment; Type: TABLE DATA; Schema: public; Owner: lbaw1614
--



--
-- Name: comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1614
--

SELECT pg_catalog.setval('comment_id_seq', 1, false);


--
-- Data for Name: comment_like; Type: TABLE DATA; Schema: public; Owner: lbaw1614
--



--
-- Data for Name: file; Type: TABLE DATA; Schema: public; Owner: lbaw1614
--



--
-- Name: file_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1614
--

SELECT pg_catalog.setval('file_id_seq', 1, false);


--
-- Data for Name: file_meeting; Type: TABLE DATA; Schema: public; Owner: lbaw1614
--



--
-- Data for Name: file_tag; Type: TABLE DATA; Schema: public; Owner: lbaw1614
--



--
-- Data for Name: forum_post; Type: TABLE DATA; Schema: public; Owner: lbaw1614
--



--
-- Name: forum_post_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1614
--

SELECT pg_catalog.setval('forum_post_id_seq', 1, false);


--
-- Data for Name: forum_post_like; Type: TABLE DATA; Schema: public; Owner: lbaw1614
--



--
-- Data for Name: forum_reply; Type: TABLE DATA; Schema: public; Owner: lbaw1614
--



--
-- Name: forum_reply_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1614
--

SELECT pg_catalog.setval('forum_reply_id_seq', 1, false);


--
-- Data for Name: forum_reply_like; Type: TABLE DATA; Schema: public; Owner: lbaw1614
--



--
-- Data for Name: meeting; Type: TABLE DATA; Schema: public; Owner: lbaw1614
--



--
-- Data for Name: project; Type: TABLE DATA; Schema: public; Owner: lbaw1614
--



--
-- Name: project_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1614
--

SELECT pg_catalog.setval('project_id_seq', 1, false);


--
-- Data for Name: tag; Type: TABLE DATA; Schema: public; Owner: lbaw1614
--



--
-- Name: tag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1614
--

SELECT pg_catalog.setval('tag_id_seq', 1, false);


--
-- Data for Name: task; Type: TABLE DATA; Schema: public; Owner: lbaw1614
--



--
-- Data for Name: task_tag; Type: TABLE DATA; Schema: public; Owner: lbaw1614
--



--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: lbaw1614
--



--
-- Data for Name: user_meeting; Type: TABLE DATA; Schema: public; Owner: lbaw1614
--



--
-- Data for Name: user_project; Type: TABLE DATA; Schema: public; Owner: lbaw1614
--



--
-- Name: Task_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1614; Tablespace: 
--

ALTER TABLE ONLY task
    ADD CONSTRAINT "Task_pkey" PRIMARY KEY (id);


--
-- Name: User_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1614; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: comment_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1614; Tablespace: 
--

ALTER TABLE ONLY comment
    ADD CONSTRAINT comment_pkey PRIMARY KEY (id);


--
-- Name: file_path_key; Type: CONSTRAINT; Schema: public; Owner: lbaw1614; Tablespace: 
--

ALTER TABLE ONLY file
    ADD CONSTRAINT file_path_key UNIQUE (path);


--
-- Name: file_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1614; Tablespace: 
--

ALTER TABLE ONLY file
    ADD CONSTRAINT file_pkey PRIMARY KEY (id);


--
-- Name: forum_post_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1614; Tablespace: 
--

ALTER TABLE ONLY forum_post
    ADD CONSTRAINT forum_post_pkey PRIMARY KEY (id);


--
-- Name: forum_reply_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1614; Tablespace: 
--

ALTER TABLE ONLY forum_reply
    ADD CONSTRAINT forum_reply_pkey PRIMARY KEY (id);


--
-- Name: meeting_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1614; Tablespace: 
--

ALTER TABLE ONLY meeting
    ADD CONSTRAINT meeting_pkey PRIMARY KEY (id);


--
-- Name: project_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1614; Tablespace: 
--

ALTER TABLE ONLY project
    ADD CONSTRAINT project_pkey PRIMARY KEY (id);


--
-- Name: tag_name_key; Type: CONSTRAINT; Schema: public; Owner: lbaw1614; Tablespace: 
--

ALTER TABLE ONLY tag
    ADD CONSTRAINT tag_name_key UNIQUE (name);


--
-- Name: tag_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1614; Tablespace: 
--

ALTER TABLE ONLY tag
    ADD CONSTRAINT tag_pkey PRIMARY KEY (id);


--
-- Name: Project-User_id-project_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY user_project
    ADD CONSTRAINT "Project-User_id-project_fkey" FOREIGN KEY (id_project) REFERENCES project(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Task_assigned-id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY task
    ADD CONSTRAINT "Task_assigned-id_fkey" FOREIGN KEY (assigned_id) REFERENCES "user"(id);


--
-- Name: Task_completer-id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY task
    ADD CONSTRAINT "Task_completer-id_fkey" FOREIGN KEY (completer_id) REFERENCES "user"(id);


--
-- Name: Task_creator-id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY task
    ADD CONSTRAINT "Task_creator-id_fkey" FOREIGN KEY (creator_id) REFERENCES "user"(id);


--
-- Name: Task_project-id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY task
    ADD CONSTRAINT "Task_project-id_fkey" FOREIGN KEY (project_id) REFERENCES project(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: comment-like_id_comment_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY comment_like
    ADD CONSTRAINT "comment-like_id_comment_fkey" FOREIGN KEY (id_comment) REFERENCES comment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: comment-like_id_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY comment_like
    ADD CONSTRAINT "comment-like_id_user_fkey" FOREIGN KEY (id_user) REFERENCES "user"(id);


--
-- Name: comment_id-task_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY comment
    ADD CONSTRAINT "comment_id-task_fkey" FOREIGN KEY (id_task) REFERENCES task(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: comment_id-user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY comment
    ADD CONSTRAINT "comment_id-user_fkey" FOREIGN KEY (id_user) REFERENCES "user"(id);


--
-- Name: file_meeting_file_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY file_meeting
    ADD CONSTRAINT file_meeting_file_id_fkey FOREIGN KEY (file_id) REFERENCES file(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: file_meeting_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY file_meeting
    ADD CONSTRAINT file_meeting_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES tag(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: file_project-id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY file
    ADD CONSTRAINT "file_project-id_fkey" FOREIGN KEY (project_id) REFERENCES project(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: file_tag_id_file_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY file_tag
    ADD CONSTRAINT file_tag_id_file_fkey FOREIGN KEY (id_file) REFERENCES file(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: file_tag_id_tag_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY file_tag
    ADD CONSTRAINT file_tag_id_tag_fkey FOREIGN KEY (id_tag) REFERENCES tag(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: file_uploader-id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY file
    ADD CONSTRAINT "file_uploader-id_fkey" FOREIGN KEY (uploader_id) REFERENCES "user"(id);


--
-- Name: forum_post_like_id_post_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY forum_post_like
    ADD CONSTRAINT forum_post_like_id_post_fkey FOREIGN KEY (id_post) REFERENCES forum_post(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: forum_post_like_id_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY forum_post_like
    ADD CONSTRAINT forum_post_like_id_user_fkey FOREIGN KEY (id_user) REFERENCES "user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: forum_reply_like_reply_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY forum_reply_like
    ADD CONSTRAINT forum_reply_like_reply_id_fkey FOREIGN KEY (reply_id) REFERENCES comment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: forum_reply_like_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY forum_reply_like
    ADD CONSTRAINT forum_reply_like_user_id_fkey FOREIGN KEY (user_id) REFERENCES "user"(id);


--
-- Name: forum_reply_post-id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY forum_reply
    ADD CONSTRAINT "forum_reply_post-id_fkey" FOREIGN KEY (post_id) REFERENCES forum_post(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: meeting_id-creator_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY meeting
    ADD CONSTRAINT "meeting_id-creator_fkey" FOREIGN KEY (id_creator) REFERENCES "user"(id);


--
-- Name: meeting_id-project_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY meeting
    ADD CONSTRAINT "meeting_id-project_fkey" FOREIGN KEY (id_project) REFERENCES project(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: task_tag_tag-id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY task_tag
    ADD CONSTRAINT "task_tag_tag-id_fkey" FOREIGN KEY (tag_id) REFERENCES tag(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: task_tag_task-id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY task_tag
    ADD CONSTRAINT "task_tag_task-id_fkey" FOREIGN KEY (task_id) REFERENCES task(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_id; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY user_project
    ADD CONSTRAINT user_id FOREIGN KEY (id_user) REFERENCES "user"(id);


--
-- Name: user_meeting_meeting-id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY user_meeting
    ADD CONSTRAINT "user_meeting_meeting-id_fkey" FOREIGN KEY (meeting_id) REFERENCES meeting(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_meeting_user-id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY user_meeting
    ADD CONSTRAINT "user_meeting_user-id_fkey" FOREIGN KEY (user_id) REFERENCES "user"(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: lbaw1614
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM lbaw1614;
GRANT ALL ON SCHEMA public TO lbaw1614;


--
-- PostgreSQL database dump complete
--

