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

--
-- Name: insertRepeatedMeetingInvite(); Type: FUNCTION; Schema: public; Owner: lbaw1614
--

CREATE FUNCTION "insertRepeatedMeetingInvite"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
  IF EXISTS (
    SELECT user_id, meeting_id FROM user_meeting
    WHERE user_id = NEW.user_id AND meeting_id = NEW.meeting_id)
  THEN
    RAISE EXCEPTION 'User already associated with the meeting';
  END IF;
  RETURN NEW;
END;$$;


ALTER FUNCTION public."insertRepeatedMeetingInvite"() OWNER TO lbaw1614;

--
-- Name: insertUserMeeting(); Type: FUNCTION; Schema: public; Owner: lbaw1614
--

CREATE FUNCTION "insertUserMeeting"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
  IF EXISTS
    (SELECT meeting_id, user_id FROM user_meeting
     WHERE user_id = NEW.id_creator AND meeting_id = NEW.id)
  THEN
    RAISE EXCEPTION 'User already associated with the meeting';
  ELSE
    INSERT INTO user_meeting(meeting_id, user_id, is_creator)
    VALUES (NEW.id, NEW.id_creator, TRUE);
  END IF;
  RETURN NEW;
END;$$;


ALTER FUNCTION public."insertUserMeeting"() OWNER TO lbaw1614;

--
-- Name: noFutureBirth(); Type: FUNCTION; Schema: public; Owner: lbaw1614
--

CREATE FUNCTION "noFutureBirth"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
  IF NEW.birth_date > NOW()
  THEN
     RAISE EXCEPTION 'birth date must be in the past';
  END IF;
  RETURN NEW;
END;$$;


ALTER FUNCTION public."noFutureBirth"() OWNER TO lbaw1614;

--
-- Name: noFutureCreationDate(); Type: FUNCTION; Schema: public; Owner: lbaw1614
--

CREATE FUNCTION "noFutureCreationDate"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
  IF NEW.creation_date > NOW()
  THEN
    RAISE EXCEPTION 'creation date must not be in the future';
  END IF;
  RETURN NEW;
END$$;


ALTER FUNCTION public."noFutureCreationDate"() OWNER TO lbaw1614;

--
-- Name: noFutureUploads(); Type: FUNCTION; Schema: public; Owner: lbaw1614
--

CREATE FUNCTION "noFutureUploads"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
  IF NEW.upload_date > NOW()
  THEN
    RAISE EXCEPTION 'upload date cannot be in the future';
  END IF;
  RETURN NEW;
END;$$;


ALTER FUNCTION public."noFutureUploads"() OWNER TO lbaw1614;

--
-- Name: noModificationAfterCreation(); Type: FUNCTION; Schema: public; Owner: lbaw1614
--

CREATE FUNCTION "noModificationAfterCreation"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
  IF NEW.date_modified < NEW.creation_date
  THEN
    RAISE EXCEPTION 'date modified cannot be before creation date';
  END IF;
  RETURN NEW;
END;$$;


ALTER FUNCTION public."noModificationAfterCreation"() OWNER TO lbaw1614;

--
-- Name: noPastMeetings(); Type: FUNCTION; Schema: public; Owner: lbaw1614
--

CREATE FUNCTION "noPastMeetings"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
  IF NEW.date < NOW()
  THEN RAISE EXCEPTION 'meeting date cannot be in the past';
  END IF;
  RETURN NEW;
END;$$;


ALTER FUNCTION public."noPastMeetings"() OWNER TO lbaw1614;

--
-- Name: noReplyBeforePost(); Type: FUNCTION; Schema: public; Owner: lbaw1614
--

CREATE FUNCTION "noReplyBeforePost"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
  IF NEW.creation_date < (SELECT date_modified FROM forum_post WHERE id = NEW.post_id)
  THEN
    RAISE EXCEPTION 'Reply can only be after the comment creation';
  END IF;
  RETURN NEW;
END;$$;


ALTER FUNCTION public."noReplyBeforePost"() OWNER TO lbaw1614;

--
-- Name: updateDateModified(); Type: FUNCTION; Schema: public; Owner: lbaw1614
--

CREATE FUNCTION "updateDateModified"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
UPDATE forum_post SET date_modified = NOW()
WHERE id = new.post_id;
return new;
END;$$;


ALTER FUNCTION public."updateDateModified"() OWNER TO lbaw1614;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: task; Type: TABLE; Schema: public; Owner: lbaw1614; Tablespace: 
--

CREATE TABLE task (
    id integer NOT NULL,
    name character varying(128) NOT NULL,
    description character varying(512),
    deadline timestamp with time zone,
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
-- Name: user_table; Type: TABLE; Schema: public; Owner: lbaw1614; Tablespace: 
--

CREATE TABLE user_table (
    id integer NOT NULL,
    name character varying(128) NOT NULL,
    username character varying(32) NOT NULL,
    email character varying(64) NOT NULL,
    password character varying(64) NOT NULL,
    phone_number character varying(32),
    photo_path character varying(256),
    birth_date date,
    country_id integer,
    city character varying(64)
);


ALTER TABLE user_table OWNER TO lbaw1614;

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

ALTER SEQUENCE "User_id_seq" OWNED BY user_table.id;


--
-- Name: comment; Type: TABLE; Schema: public; Owner: lbaw1614; Tablespace: 
--

CREATE TABLE comment (
    id integer NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    content character varying(512) NOT NULL,
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
-- Name: country; Type: TABLE; Schema: public; Owner: lbaw1614; Tablespace: 
--

CREATE TABLE country (
    id integer NOT NULL,
    name character varying(64)
);


ALTER TABLE country OWNER TO lbaw1614;

--
-- Name: file; Type: TABLE; Schema: public; Owner: lbaw1614; Tablespace: 
--

CREATE TABLE file (
    id integer NOT NULL,
    upload_date timestamp with time zone NOT NULL,
    uploader_id integer NOT NULL,
    project_id integer NOT NULL,
    name character varying(64) NOT NULL,
    path character varying(64) NOT NULL
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
    meeting_id integer NOT NULL
);


ALTER TABLE file_meeting OWNER TO lbaw1614;

--
-- Name: file_tag; Type: TABLE; Schema: public; Owner: lbaw1614; Tablespace: 
--

CREATE TABLE file_tag (
    tag_id integer NOT NULL,
    file_id integer NOT NULL
);


ALTER TABLE file_tag OWNER TO lbaw1614;

--
-- Name: forum_post; Type: TABLE; Schema: public; Owner: lbaw1614; Tablespace: 
--

CREATE TABLE forum_post (
    id integer NOT NULL,
    title character varying(128) NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    content character varying(512) NOT NULL,
    id_project integer NOT NULL,
    date_modified timestamp with time zone NOT NULL,
    id_creator integer NOT NULL
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
    creation_date timestamp with time zone NOT NULL,
    content character varying(512) NOT NULL,
    post_id integer NOT NULL,
    creator_id integer NOT NULL
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
    name character varying(64) NOT NULL,
    date timestamp with time zone NOT NULL,
    duration integer,
    description character varying(512),
    id_creator integer NOT NULL,
    id_project integer NOT NULL
);


ALTER TABLE meeting OWNER TO lbaw1614;

--
-- Name: project; Type: TABLE; Schema: public; Owner: lbaw1614; Tablespace: 
--

CREATE TABLE project (
    id integer NOT NULL,
    name character varying(64) NOT NULL,
    description character varying(512)
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
    name character varying(32) NOT NULL
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
    meeting_id integer NOT NULL,
    user_id integer NOT NULL,
    is_creator boolean DEFAULT false NOT NULL
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

ALTER TABLE ONLY user_table ALTER COLUMN id SET DEFAULT nextval('"User_id_seq"'::regclass);


--
-- Name: Task_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1614
--

SELECT pg_catalog.setval('"Task_id_seq"', 1, false);


--
-- Name: User_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1614
--

SELECT pg_catalog.setval('"User_id_seq"', 3, true);


--
-- Data for Name: comment; Type: TABLE DATA; Schema: public; Owner: lbaw1614
--

INSERT INTO comment VALUES (1, '2017-08-02 00:00:00+01', 'orci', 83, 20);
INSERT INTO comment VALUES (2, '2015-10-25 00:00:00+01', 'ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu', 85, 22);
INSERT INTO comment VALUES (3, '2016-04-30 00:00:00+01', 'ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi', 84, 251);
INSERT INTO comment VALUES (4, '2017-12-03 00:00:00+00', 'a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est', 37, 65);
INSERT INTO comment VALUES (5, '2015-11-11 00:00:00+00', 'risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet', 100, 204);
INSERT INTO comment VALUES (6, '2018-01-22 00:00:00+00', 'eros suspendisse accumsan tortor quis turpis sed ante', 69, 68);
INSERT INTO comment VALUES (7, '2016-05-04 00:00:00+01', 'eros suspendisse accumsan', 65, 127);
INSERT INTO comment VALUES (8, '2016-08-18 00:00:00+01', 'aliquam erat volutpat in congue etiam justo etiam pretium iaculis', 98, 251);
INSERT INTO comment VALUES (9, '2017-03-20 00:00:00+00', 'dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor vel est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis', 22, 26);
INSERT INTO comment VALUES (10, '2015-04-04 00:00:00+01', 'vel', 38, 93);
INSERT INTO comment VALUES (11, '2015-08-15 00:00:00+01', 'sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus', 77, 277);
INSERT INTO comment VALUES (12, '2016-09-24 00:00:00+01', 'varius ut blandit non interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis', 84, 221);
INSERT INTO comment VALUES (13, '2015-08-18 00:00:00+01', 'mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac', 3, 129);
INSERT INTO comment VALUES (14, '2016-06-18 00:00:00+01', 'ipsum dolor sit amet consectetuer adipiscing elit proin risus praesent lectus vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus', 70, 77);
INSERT INTO comment VALUES (15, '2017-05-26 00:00:00+01', 'id consequat in', 85, 190);
INSERT INTO comment VALUES (16, '2016-01-17 00:00:00+00', 'donec dapibus duis at', 31, 173);
INSERT INTO comment VALUES (17, '2017-12-02 00:00:00+00', 'eleifend pede libero quis', 51, 76);
INSERT INTO comment VALUES (18, '2018-02-11 00:00:00+00', 'sit amet eleifend pede libero quis orci', 93, 91);
INSERT INTO comment VALUES (19, '2015-11-27 00:00:00+00', 'sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque', 68, 294);
INSERT INTO comment VALUES (20, '2017-04-02 00:00:00+01', 'dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse', 74, 6);
INSERT INTO comment VALUES (21, '2016-01-04 00:00:00+00', 'proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula', 11, 290);
INSERT INTO comment VALUES (22, '2015-10-09 00:00:00+01', 'ligula sit amet eleifend', 45, 240);
INSERT INTO comment VALUES (23, '2017-10-16 00:00:00+01', 'vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in hac habitasse platea', 67, 191);
INSERT INTO comment VALUES (24, '2015-04-25 00:00:00+01', 'vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus', 88, 118);
INSERT INTO comment VALUES (25, '2015-07-30 00:00:00+01', 'consequat lectus in est risus auctor sed tristique in tempus sit amet sem fusce consequat nulla nisl nunc', 6, 40);
INSERT INTO comment VALUES (26, '2017-08-18 00:00:00+01', 'hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer', 53, 20);
INSERT INTO comment VALUES (27, '2015-05-10 00:00:00+01', 'fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam', 46, 209);
INSERT INTO comment VALUES (28, '2015-06-04 00:00:00+01', 'interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla', 9, 297);
INSERT INTO comment VALUES (29, '2017-12-09 00:00:00+00', 'hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam', 82, 254);
INSERT INTO comment VALUES (30, '2017-05-24 00:00:00+01', 'amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id', 84, 56);
INSERT INTO comment VALUES (31, '2017-01-12 00:00:00+00', 'nunc rhoncus dui vel sem', 19, 28);
INSERT INTO comment VALUES (32, '2016-05-19 00:00:00+01', 'volutpat convallis morbi odio odio elementum eu', 28, 118);
INSERT INTO comment VALUES (33, '2017-12-15 00:00:00+00', 'non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas', 7, 116);
INSERT INTO comment VALUES (34, '2017-07-27 00:00:00+01', 'sapien varius ut blandit non interdum in ante vestibulum', 26, 278);
INSERT INTO comment VALUES (35, '2016-07-12 00:00:00+01', 'dictumst morbi vestibulum velit id pretium iaculis diam erat', 39, 78);
INSERT INTO comment VALUES (36, '2017-11-16 00:00:00+00', 'mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea', 31, 199);
INSERT INTO comment VALUES (37, '2017-02-13 00:00:00+00', 'natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis', 3, 149);
INSERT INTO comment VALUES (38, '2016-07-12 00:00:00+01', 'primis in faucibus orci', 47, 267);
INSERT INTO comment VALUES (39, '2018-03-17 00:00:00+00', 'semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis', 39, 44);
INSERT INTO comment VALUES (40, '2016-12-12 00:00:00+00', 'aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio', 77, 281);
INSERT INTO comment VALUES (41, '2017-06-30 00:00:00+01', 'lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam', 73, 187);
INSERT INTO comment VALUES (42, '2017-01-23 00:00:00+00', 'adipiscing lorem vitae mattis nibh ligula nec', 99, 260);
INSERT INTO comment VALUES (43, '2017-02-22 00:00:00+00', 'dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula', 16, 203);
INSERT INTO comment VALUES (44, '2015-07-16 00:00:00+01', 'consequat in consequat ut nulla sed accumsan felis ut at dolor quis', 33, 3);
INSERT INTO comment VALUES (45, '2017-08-11 00:00:00+01', 'cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus', 30, 281);
INSERT INTO comment VALUES (46, '2017-04-15 00:00:00+01', 'justo etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non', 20, 239);
INSERT INTO comment VALUES (47, '2016-05-09 00:00:00+01', 'morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis', 82, 146);
INSERT INTO comment VALUES (48, '2017-01-12 00:00:00+00', 'dis parturient montes nascetur ridiculus mus', 92, 160);
INSERT INTO comment VALUES (49, '2016-08-25 00:00:00+01', 'id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor vel est donec odio justo sollicitudin ut suscipit a', 30, 126);
INSERT INTO comment VALUES (50, '2017-04-21 00:00:00+01', 'id ornare imperdiet sapien urna pretium', 45, 12);
INSERT INTO comment VALUES (51, '2015-11-08 00:00:00+00', 'habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus vel nulla', 66, 151);
INSERT INTO comment VALUES (52, '2017-06-05 00:00:00+01', 'duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti', 74, 277);
INSERT INTO comment VALUES (53, '2017-09-22 00:00:00+01', 'mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus', 72, 159);
INSERT INTO comment VALUES (54, '2017-09-11 00:00:00+01', 'enim lorem ipsum dolor', 46, 181);
INSERT INTO comment VALUES (55, '2016-05-05 00:00:00+01', 'porttitor pede justo eu massa donec', 33, 244);
INSERT INTO comment VALUES (56, '2016-01-16 00:00:00+00', 'non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl', 26, 67);
INSERT INTO comment VALUES (57, '2016-01-19 00:00:00+00', 'phasellus in felis donec semper sapien a', 22, 93);
INSERT INTO comment VALUES (58, '2015-12-21 00:00:00+00', 'ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae', 98, 287);
INSERT INTO comment VALUES (59, '2016-10-14 00:00:00+01', 'suspendisse', 86, 272);
INSERT INTO comment VALUES (60, '2016-05-24 00:00:00+01', 'gravida nisi at nibh in hac', 67, 110);
INSERT INTO comment VALUES (61, '2015-09-26 00:00:00+01', 'nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel dapibus at', 69, 127);
INSERT INTO comment VALUES (62, '2015-11-20 00:00:00+00', 'vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam', 10, 224);
INSERT INTO comment VALUES (63, '2017-03-30 00:00:00+01', 'curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque', 71, 151);
INSERT INTO comment VALUES (64, '2016-05-07 00:00:00+01', 'purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor', 79, 102);
INSERT INTO comment VALUES (65, '2016-03-28 00:00:00+01', 'non interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec', 63, 225);
INSERT INTO comment VALUES (66, '2017-07-02 00:00:00+01', 'nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula', 8, 140);
INSERT INTO comment VALUES (67, '2015-04-02 00:00:00+01', 'risus dapibus augue vel accumsan tellus nisi eu orci', 81, 241);
INSERT INTO comment VALUES (68, '2016-07-06 00:00:00+01', 'donec ut mauris eget massa tempor', 45, 173);
INSERT INTO comment VALUES (69, '2017-04-12 00:00:00+01', 'suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel dapibus', 68, 77);
INSERT INTO comment VALUES (70, '2016-12-15 00:00:00+00', 'rutrum neque aenean auctor gravida sem praesent id', 9, 152);
INSERT INTO comment VALUES (71, '2017-12-28 00:00:00+00', 'ante vivamus tortor duis mattis egestas metus aenean fermentum donec', 58, 217);
INSERT INTO comment VALUES (72, '2016-11-20 00:00:00+00', 'cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor', 90, 9);
INSERT INTO comment VALUES (73, '2015-05-23 00:00:00+01', 'justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis', 21, 264);
INSERT INTO comment VALUES (74, '2016-12-02 00:00:00+00', 'curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh', 89, 217);
INSERT INTO comment VALUES (75, '2017-08-26 00:00:00+01', 'nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris', 63, 117);
INSERT INTO comment VALUES (76, '2016-07-28 00:00:00+01', 'dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere', 7, 180);
INSERT INTO comment VALUES (77, '2017-08-20 00:00:00+01', 'justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor vel est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id', 9, 14);
INSERT INTO comment VALUES (78, '2017-09-24 00:00:00+01', 'praesent lectus vestibulum quam sapien', 9, 58);
INSERT INTO comment VALUES (79, '2016-05-30 00:00:00+01', 'sapien quis libero nullam sit amet turpis', 12, 236);
INSERT INTO comment VALUES (80, '2017-01-23 00:00:00+00', 'est congue elementum in', 47, 109);
INSERT INTO comment VALUES (81, '2015-10-07 00:00:00+01', 'congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante', 20, 97);
INSERT INTO comment VALUES (82, '2016-11-05 00:00:00+00', 'vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id', 91, 245);
INSERT INTO comment VALUES (83, '2016-03-08 00:00:00+00', 'amet consectetuer adipiscing elit proin risus praesent lectus vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus', 69, 287);
INSERT INTO comment VALUES (84, '2016-06-18 00:00:00+01', 'nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel dapibus at diam nam tristique tortor', 58, 81);
INSERT INTO comment VALUES (755, '2015-10-25 00:00:00+01', 'vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci', 39, 31);
INSERT INTO comment VALUES (85, '2018-01-29 00:00:00+00', 'molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat', 83, 228);
INSERT INTO comment VALUES (86, '2018-01-01 00:00:00+00', 'faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget', 36, 160);
INSERT INTO comment VALUES (87, '2015-04-22 00:00:00+01', 'euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec', 43, 280);
INSERT INTO comment VALUES (88, '2015-04-12 00:00:00+01', 'fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim', 46, 142);
INSERT INTO comment VALUES (89, '2015-06-09 00:00:00+01', 'et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum', 23, 238);
INSERT INTO comment VALUES (90, '2015-09-19 00:00:00+01', 'natoque penatibus et magnis dis parturient montes nascetur ridiculus', 4, 288);
INSERT INTO comment VALUES (91, '2015-05-04 00:00:00+01', 'integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar', 9, 150);
INSERT INTO comment VALUES (92, '2016-07-04 00:00:00+01', 'dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula', 61, 174);
INSERT INTO comment VALUES (93, '2016-04-23 00:00:00+01', 'ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin', 43, 125);
INSERT INTO comment VALUES (94, '2016-07-24 00:00:00+01', 'ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor vel est donec odio justo sollicitudin ut suscipit', 79, 34);
INSERT INTO comment VALUES (95, '2017-07-01 00:00:00+01', 'ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci', 50, 142);
INSERT INTO comment VALUES (96, '2017-06-14 00:00:00+01', 'at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet sem fusce consequat nulla nisl nunc', 51, 146);
INSERT INTO comment VALUES (97, '2018-01-10 00:00:00+00', 'sollicitudin mi sit amet lobortis', 50, 155);
INSERT INTO comment VALUES (98, '2016-07-20 00:00:00+01', 'sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus', 56, 75);
INSERT INTO comment VALUES (99, '2017-06-17 00:00:00+01', 'suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac', 9, 211);
INSERT INTO comment VALUES (100, '2017-05-29 00:00:00+01', 'quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer', 86, 261);
INSERT INTO comment VALUES (101, '2016-08-21 00:00:00+01', 'turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit', 86, 185);
INSERT INTO comment VALUES (102, '2016-03-31 00:00:00+01', 'parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam', 39, 286);
INSERT INTO comment VALUES (103, '2016-07-08 00:00:00+01', 'ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas', 74, 43);
INSERT INTO comment VALUES (104, '2016-04-17 00:00:00+01', 'aliquet maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et', 8, 160);
INSERT INTO comment VALUES (105, '2016-08-11 00:00:00+01', 'et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl', 41, 66);
INSERT INTO comment VALUES (106, '2017-01-14 00:00:00+00', 'sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla', 57, 91);
INSERT INTO comment VALUES (107, '2015-04-20 00:00:00+01', 'orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor', 55, 263);
INSERT INTO comment VALUES (108, '2016-04-27 00:00:00+01', 'amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa', 37, 235);
INSERT INTO comment VALUES (109, '2016-02-17 00:00:00+00', 'quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor vel est donec odio justo sollicitudin', 91, 251);
INSERT INTO comment VALUES (110, '2017-08-20 00:00:00+01', 'pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est', 75, 170);
INSERT INTO comment VALUES (111, '2016-02-03 00:00:00+00', 'luctus et ultrices posuere cubilia curae nulla dapibus dolor vel est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl', 55, 227);
INSERT INTO comment VALUES (112, '2017-12-07 00:00:00+00', 'est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam', 86, 154);
INSERT INTO comment VALUES (113, '2016-08-14 00:00:00+01', 'velit vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget', 45, 3);
INSERT INTO comment VALUES (114, '2015-06-17 00:00:00+01', 'ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh', 8, 103);
INSERT INTO comment VALUES (115, '2015-04-30 00:00:00+01', 'interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec', 13, 83);
INSERT INTO comment VALUES (116, '2015-11-29 00:00:00+00', 'volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit', 10, 252);
INSERT INTO comment VALUES (117, '2016-11-01 00:00:00+00', 'nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in', 48, 4);
INSERT INTO comment VALUES (118, '2015-12-05 00:00:00+00', 'maecenas leo odio condimentum', 95, 265);
INSERT INTO comment VALUES (119, '2018-02-16 00:00:00+00', 'nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero', 48, 77);
INSERT INTO comment VALUES (120, '2015-11-13 00:00:00+00', 'dolor sit amet consectetuer', 35, 187);
INSERT INTO comment VALUES (121, '2017-05-07 00:00:00+01', 'purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut', 2, 77);
INSERT INTO comment VALUES (122, '2016-06-30 00:00:00+01', 'orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui', 1, 186);
INSERT INTO comment VALUES (123, '2018-01-08 00:00:00+00', 'lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet', 25, 290);
INSERT INTO comment VALUES (124, '2017-12-30 00:00:00+00', 'consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit', 83, 116);
INSERT INTO comment VALUES (125, '2015-05-12 00:00:00+01', 'montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi ut', 81, 3);
INSERT INTO comment VALUES (126, '2016-12-20 00:00:00+00', 'ut blandit non interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim', 82, 171);
INSERT INTO comment VALUES (127, '2018-01-04 00:00:00+00', 'justo etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt', 69, 133);
INSERT INTO comment VALUES (128, '2017-02-28 00:00:00+00', 'pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor', 90, 202);
INSERT INTO comment VALUES (129, '2015-12-27 00:00:00+00', 'quisque porta volutpat erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor', 86, 223);
INSERT INTO comment VALUES (130, '2017-11-07 00:00:00+00', 'in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus', 45, 114);
INSERT INTO comment VALUES (131, '2017-02-17 00:00:00+00', 'etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus vel nulla', 81, 245);
INSERT INTO comment VALUES (132, '2016-02-02 00:00:00+00', 'vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam', 23, 67);
INSERT INTO comment VALUES (133, '2016-03-06 00:00:00+00', 'maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien', 55, 43);
INSERT INTO comment VALUES (134, '2016-05-30 00:00:00+01', 'vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget semper', 66, 195);
INSERT INTO comment VALUES (135, '2016-05-24 00:00:00+01', 'mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas', 2, 108);
INSERT INTO comment VALUES (136, '2016-01-08 00:00:00+00', 'leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus', 55, 285);
INSERT INTO comment VALUES (137, '2016-03-04 00:00:00+00', 'ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor vel est donec odio justo sollicitudin ut suscipit a feugiat', 31, 120);
INSERT INTO comment VALUES (138, '2016-08-13 00:00:00+01', 'mattis pulvinar', 98, 85);
INSERT INTO comment VALUES (139, '2015-09-20 00:00:00+01', 'sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque', 37, 224);
INSERT INTO comment VALUES (140, '2015-10-16 00:00:00+01', 'sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at', 63, 171);
INSERT INTO comment VALUES (141, '2017-07-19 00:00:00+01', 'vel est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce', 96, 135);
INSERT INTO comment VALUES (142, '2015-04-12 00:00:00+01', 'ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi', 81, 131);
INSERT INTO comment VALUES (143, '2016-08-27 00:00:00+01', 'ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut', 96, 299);
INSERT INTO comment VALUES (144, '2015-06-05 00:00:00+01', 'elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis', 8, 125);
INSERT INTO comment VALUES (145, '2016-12-02 00:00:00+00', 'mi sit amet lobortis', 36, 43);
INSERT INTO comment VALUES (146, '2015-06-24 00:00:00+01', 'sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae', 28, 102);
INSERT INTO comment VALUES (147, '2016-11-01 00:00:00+00', 'interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel dapibus at diam', 92, 285);
INSERT INTO comment VALUES (148, '2016-06-04 00:00:00+01', 'bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed', 29, 34);
INSERT INTO comment VALUES (149, '2015-12-27 00:00:00+00', 'dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit', 22, 70);
INSERT INTO comment VALUES (150, '2015-09-26 00:00:00+01', 'in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id', 54, 105);
INSERT INTO comment VALUES (151, '2017-02-21 00:00:00+00', 'ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem', 2, 66);
INSERT INTO comment VALUES (152, '2015-12-04 00:00:00+00', 'vel accumsan tellus nisi eu orci mauris', 63, 79);
INSERT INTO comment VALUES (153, '2016-06-28 00:00:00+01', 'nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis', 97, 178);
INSERT INTO comment VALUES (154, '2015-03-31 00:00:00+01', 'luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam', 66, 150);
INSERT INTO comment VALUES (155, '2017-01-22 00:00:00+00', 'quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla', 34, 259);
INSERT INTO comment VALUES (156, '2018-03-09 00:00:00+00', 'vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam', 82, 35);
INSERT INTO comment VALUES (157, '2016-07-28 00:00:00+01', 'posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem', 96, 189);
INSERT INTO comment VALUES (158, '2016-08-12 00:00:00+01', 'aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero', 70, 250);
INSERT INTO comment VALUES (159, '2016-12-23 00:00:00+00', 'integer', 72, 49);
INSERT INTO comment VALUES (160, '2015-03-27 00:00:00+00', 'vulputate elementum nullam', 8, 282);
INSERT INTO comment VALUES (161, '2015-12-11 00:00:00+00', 'enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit', 18, 68);
INSERT INTO comment VALUES (162, '2016-08-21 00:00:00+01', 'mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis', 47, 221);
INSERT INTO comment VALUES (163, '2017-04-01 00:00:00+01', 'massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus', 65, 278);
INSERT INTO comment VALUES (164, '2015-05-07 00:00:00+01', 'et magnis dis parturient montes nascetur', 47, 100);
INSERT INTO comment VALUES (165, '2017-10-08 00:00:00+01', 'luctus et ultrices posuere', 52, 161);
INSERT INTO comment VALUES (166, '2015-08-12 00:00:00+01', 'vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer', 50, 100);
INSERT INTO comment VALUES (167, '2017-02-12 00:00:00+00', 'semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis', 45, 178);
INSERT INTO comment VALUES (168, '2016-06-13 00:00:00+01', 'iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum', 26, 97);
INSERT INTO comment VALUES (169, '2017-02-21 00:00:00+00', 'posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem', 5, 6);
INSERT INTO comment VALUES (170, '2018-03-07 00:00:00+00', 'eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse', 78, 183);
INSERT INTO comment VALUES (171, '2016-08-13 00:00:00+01', 'amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices', 70, 209);
INSERT INTO comment VALUES (172, '2016-04-29 00:00:00+01', 'eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna', 45, 197);
INSERT INTO comment VALUES (173, '2015-05-24 00:00:00+01', 'nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula', 63, 79);
INSERT INTO comment VALUES (174, '2016-10-22 00:00:00+01', 'rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend', 69, 276);
INSERT INTO comment VALUES (175, '2016-07-20 00:00:00+01', 'enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam', 45, 118);
INSERT INTO comment VALUES (176, '2015-05-30 00:00:00+01', 'at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus', 99, 106);
INSERT INTO comment VALUES (177, '2017-02-14 00:00:00+00', 'turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales', 10, 127);
INSERT INTO comment VALUES (178, '2016-02-10 00:00:00+00', 'id nulla ultrices aliquet maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus', 3, 160);
INSERT INTO comment VALUES (179, '2017-08-15 00:00:00+01', 'lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie', 17, 287);
INSERT INTO comment VALUES (180, '2015-09-09 00:00:00+01', 'ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac', 100, 33);
INSERT INTO comment VALUES (181, '2016-12-23 00:00:00+00', 'nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi', 80, 131);
INSERT INTO comment VALUES (182, '2016-07-18 00:00:00+01', 'elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas', 99, 173);
INSERT INTO comment VALUES (183, '2016-08-25 00:00:00+01', 'quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at', 85, 105);
INSERT INTO comment VALUES (184, '2016-02-12 00:00:00+00', 'duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere', 48, 195);
INSERT INTO comment VALUES (185, '2017-07-09 00:00:00+01', 'adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere nonummy integer', 85, 2);
INSERT INTO comment VALUES (186, '2016-07-19 00:00:00+01', 'vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur', 92, 157);
INSERT INTO comment VALUES (187, '2015-10-15 00:00:00+01', 'nec dui luctus rutrum nulla tellus in sagittis', 17, 177);
INSERT INTO comment VALUES (188, '2015-12-28 00:00:00+00', 'porta volutpat erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui', 46, 96);
INSERT INTO comment VALUES (189, '2016-05-09 00:00:00+01', 'nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien', 5, 172);
INSERT INTO comment VALUES (190, '2017-08-04 00:00:00+01', 'justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia', 64, 265);
INSERT INTO comment VALUES (444, '2015-11-26 00:00:00+00', 'volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum', 6, 38);
INSERT INTO comment VALUES (191, '2016-07-08 00:00:00+01', 'dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus', 72, 173);
INSERT INTO comment VALUES (192, '2016-03-14 00:00:00+00', 'eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut', 93, 40);
INSERT INTO comment VALUES (193, '2016-02-09 00:00:00+00', 'ornare imperdiet sapien', 25, 77);
INSERT INTO comment VALUES (194, '2016-01-23 00:00:00+00', 'natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi', 71, 22);
INSERT INTO comment VALUES (195, '2016-07-08 00:00:00+01', 'vestibulum', 60, 30);
INSERT INTO comment VALUES (196, '2015-08-30 00:00:00+01', 'enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget', 100, 199);
INSERT INTO comment VALUES (197, '2017-10-18 00:00:00+01', 'amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus', 40, 4);
INSERT INTO comment VALUES (198, '2015-08-01 00:00:00+01', 'sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut', 50, 35);
INSERT INTO comment VALUES (199, '2018-02-13 00:00:00+00', 'at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet sem fusce consequat', 76, 235);
INSERT INTO comment VALUES (200, '2015-08-12 00:00:00+01', 'semper rutrum nulla nunc purus phasellus in', 67, 245);
INSERT INTO comment VALUES (201, '2017-03-01 00:00:00+00', 'erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio', 61, 29);
INSERT INTO comment VALUES (202, '2016-12-22 00:00:00+00', 'nisl venenatis', 57, 119);
INSERT INTO comment VALUES (203, '2015-09-01 00:00:00+01', 'duis at', 93, 232);
INSERT INTO comment VALUES (204, '2015-08-23 00:00:00+01', 'integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla', 41, 55);
INSERT INTO comment VALUES (205, '2017-01-30 00:00:00+00', 'maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices', 6, 112);
INSERT INTO comment VALUES (206, '2015-05-08 00:00:00+01', 'tortor sollicitudin mi sit amet lobortis sapien sapien non', 46, 14);
INSERT INTO comment VALUES (207, '2016-10-19 00:00:00+01', 'quis lectus suspendisse', 38, 212);
INSERT INTO comment VALUES (208, '2017-04-22 00:00:00+01', 'consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec', 67, 206);
INSERT INTO comment VALUES (209, '2016-01-05 00:00:00+00', 'adipiscing elit proin risus praesent lectus vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in', 12, 120);
INSERT INTO comment VALUES (210, '2015-07-21 00:00:00+01', 'pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue', 91, 61);
INSERT INTO comment VALUES (211, '2017-03-25 00:00:00+00', 'congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis', 31, 7);
INSERT INTO comment VALUES (212, '2017-03-26 00:00:00+00', 'primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor vel est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue', 54, 102);
INSERT INTO comment VALUES (213, '2015-09-07 00:00:00+01', 'egestas metus aenean fermentum donec ut mauris eget', 82, 176);
INSERT INTO comment VALUES (214, '2017-11-19 00:00:00+00', 'ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim', 28, 260);
INSERT INTO comment VALUES (215, '2016-03-16 00:00:00+00', 'vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat', 45, 145);
INSERT INTO comment VALUES (216, '2015-10-27 00:00:00+00', 'duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet', 93, 74);
INSERT INTO comment VALUES (217, '2016-06-12 00:00:00+01', 'odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar', 49, 236);
INSERT INTO comment VALUES (218, '2017-07-27 00:00:00+01', 'ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis', 73, 274);
INSERT INTO comment VALUES (219, '2017-09-17 00:00:00+01', 'ante nulla justo aliquam quis turpis', 30, 62);
INSERT INTO comment VALUES (220, '2017-02-25 00:00:00+00', 'luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum', 70, 206);
INSERT INTO comment VALUES (221, '2017-12-15 00:00:00+00', 'tincidunt lacus at velit vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget', 83, 222);
INSERT INTO comment VALUES (222, '2015-06-01 00:00:00+01', 'curae nulla dapibus dolor vel est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue', 87, 224);
INSERT INTO comment VALUES (223, '2017-08-11 00:00:00+01', 'vitae quam suspendisse potenti', 65, 259);
INSERT INTO comment VALUES (224, '2016-12-27 00:00:00+00', 'morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus', 56, 167);
INSERT INTO comment VALUES (225, '2016-12-22 00:00:00+00', 'eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor id', 48, 247);
INSERT INTO comment VALUES (226, '2017-10-27 00:00:00+01', 'dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel dapibus at diam nam tristique tortor', 66, 105);
INSERT INTO comment VALUES (227, '2016-12-07 00:00:00+00', 'lectus in est risus auctor sed tristique in tempus sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum', 52, 154);
INSERT INTO comment VALUES (228, '2017-03-17 00:00:00+00', 'aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et', 10, 254);
INSERT INTO comment VALUES (229, '2018-02-07 00:00:00+00', 'cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla', 72, 73);
INSERT INTO comment VALUES (445, '2018-02-25 00:00:00+00', 'platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non', 76, 174);
INSERT INTO comment VALUES (230, '2017-10-26 00:00:00+01', 'erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer ac leo', 47, 32);
INSERT INTO comment VALUES (231, '2015-12-20 00:00:00+00', 'primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis', 81, 172);
INSERT INTO comment VALUES (232, '2016-10-02 00:00:00+01', 'quam a odio in hac', 13, 28);
INSERT INTO comment VALUES (233, '2017-03-20 00:00:00+00', 'congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat', 44, 137);
INSERT INTO comment VALUES (234, '2016-11-18 00:00:00+00', 'eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan', 57, 85);
INSERT INTO comment VALUES (235, '2016-01-20 00:00:00+00', 'id justo sit amet', 35, 136);
INSERT INTO comment VALUES (236, '2017-06-12 00:00:00+01', 'quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat', 22, 106);
INSERT INTO comment VALUES (237, '2015-10-08 00:00:00+01', 'faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non', 1, 133);
INSERT INTO comment VALUES (238, '2017-02-14 00:00:00+00', 'tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend', 60, 269);
INSERT INTO comment VALUES (239, '2015-09-25 00:00:00+01', 'dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus', 6, 177);
INSERT INTO comment VALUES (240, '2016-01-09 00:00:00+00', 'suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum', 22, 159);
INSERT INTO comment VALUES (241, '2015-03-27 00:00:00+00', 'pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas', 49, 273);
INSERT INTO comment VALUES (242, '2016-03-23 00:00:00+00', 'nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse', 64, 119);
INSERT INTO comment VALUES (243, '2017-01-20 00:00:00+00', 'amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer', 3, 25);
INSERT INTO comment VALUES (244, '2017-03-08 00:00:00+00', 'ipsum dolor sit amet consectetuer adipiscing elit proin risus praesent lectus', 8, 224);
INSERT INTO comment VALUES (245, '2017-04-29 00:00:00+01', 'bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero', 53, 157);
INSERT INTO comment VALUES (246, '2017-12-08 00:00:00+00', 'ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat', 6, 176);
INSERT INTO comment VALUES (247, '2016-10-16 00:00:00+01', 'vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar', 37, 66);
INSERT INTO comment VALUES (248, '2015-10-21 00:00:00+01', 'erat volutpat in congue etiam justo etiam pretium iaculis justo in hac habitasse platea', 68, 67);
INSERT INTO comment VALUES (249, '2016-11-28 00:00:00+00', 'vel nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea', 5, 146);
INSERT INTO comment VALUES (250, '2016-11-16 00:00:00+00', 'sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id', 28, 12);
INSERT INTO comment VALUES (251, '2015-08-11 00:00:00+01', 'ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac', 94, 245);
INSERT INTO comment VALUES (252, '2016-01-03 00:00:00+00', 'sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer', 63, 122);
INSERT INTO comment VALUES (253, '2017-10-24 00:00:00+01', 'nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo', 93, 259);
INSERT INTO comment VALUES (254, '2017-12-28 00:00:00+00', 'quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor vel est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam', 41, 96);
INSERT INTO comment VALUES (255, '2017-03-08 00:00:00+00', 'nec nisi volutpat eleifend donec ut dolor', 21, 133);
INSERT INTO comment VALUES (256, '2017-07-03 00:00:00+01', 'libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet', 26, 227);
INSERT INTO comment VALUES (257, '2017-01-02 00:00:00+00', 'orci pede venenatis non', 1, 123);
INSERT INTO comment VALUES (258, '2017-01-06 00:00:00+00', 'luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse', 22, 300);
INSERT INTO comment VALUES (259, '2015-07-07 00:00:00+01', 'eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia', 4, 82);
INSERT INTO comment VALUES (260, '2015-05-17 00:00:00+01', 'curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit', 36, 200);
INSERT INTO comment VALUES (261, '2016-01-19 00:00:00+00', 'amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque', 6, 238);
INSERT INTO comment VALUES (262, '2015-12-04 00:00:00+00', 'posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam', 20, 178);
INSERT INTO comment VALUES (263, '2016-08-23 00:00:00+01', 'ultrices posuere cubilia curae', 2, 215);
INSERT INTO comment VALUES (264, '2016-12-08 00:00:00+00', 'posuere cubilia curae nulla dapibus dolor vel est donec', 4, 184);
INSERT INTO comment VALUES (446, '2017-10-23 00:00:00+01', 'et ultrices posuere', 56, 21);
INSERT INTO comment VALUES (265, '2017-01-19 00:00:00+00', 'libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi', 14, 192);
INSERT INTO comment VALUES (266, '2015-06-15 00:00:00+01', 'ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare', 16, 233);
INSERT INTO comment VALUES (267, '2016-10-04 00:00:00+01', 'platea dictumst etiam faucibus', 27, 222);
INSERT INTO comment VALUES (268, '2017-05-20 00:00:00+01', 'enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis', 71, 53);
INSERT INTO comment VALUES (269, '2016-09-15 00:00:00+01', 'id consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam', 44, 81);
INSERT INTO comment VALUES (270, '2017-06-15 00:00:00+01', 'cras in purus eu', 2, 111);
INSERT INTO comment VALUES (271, '2016-04-07 00:00:00+01', 'eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in', 84, 3);
INSERT INTO comment VALUES (272, '2016-10-28 00:00:00+01', 'nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus', 21, 125);
INSERT INTO comment VALUES (273, '2016-03-08 00:00:00+00', 'nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien', 90, 160);
INSERT INTO comment VALUES (274, '2015-09-21 00:00:00+01', 'mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula', 51, 262);
INSERT INTO comment VALUES (275, '2015-04-19 00:00:00+01', 'tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel dapibus at diam nam tristique tortor eu', 92, 29);
INSERT INTO comment VALUES (276, '2018-01-19 00:00:00+00', 'duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea', 22, 120);
INSERT INTO comment VALUES (277, '2016-08-17 00:00:00+01', 'magna ac', 85, 87);
INSERT INTO comment VALUES (278, '2017-08-13 00:00:00+01', 'nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus', 14, 160);
INSERT INTO comment VALUES (279, '2015-12-05 00:00:00+00', 'pellentesque ultrices phasellus id sapien in sapien', 27, 235);
INSERT INTO comment VALUES (280, '2017-05-12 00:00:00+01', 'sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta', 21, 236);
INSERT INTO comment VALUES (281, '2018-02-03 00:00:00+00', 'sollicitudin mi sit amet lobortis sapien sapien', 96, 29);
INSERT INTO comment VALUES (282, '2015-04-09 00:00:00+01', 'donec', 56, 136);
INSERT INTO comment VALUES (283, '2015-09-04 00:00:00+01', 'at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra', 29, 138);
INSERT INTO comment VALUES (284, '2017-05-01 00:00:00+01', 'sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus', 61, 203);
INSERT INTO comment VALUES (285, '2017-05-06 00:00:00+01', 'volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus', 41, 64);
INSERT INTO comment VALUES (286, '2017-12-22 00:00:00+00', 'fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse', 34, 182);
INSERT INTO comment VALUES (287, '2015-09-29 00:00:00+01', 'sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque', 37, 111);
INSERT INTO comment VALUES (288, '2016-04-03 00:00:00+01', 'erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel', 52, 52);
INSERT INTO comment VALUES (289, '2016-09-24 00:00:00+01', 'felis donec semper sapien', 16, 101);
INSERT INTO comment VALUES (290, '2017-04-17 00:00:00+01', 'semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse', 92, 55);
INSERT INTO comment VALUES (291, '2018-02-17 00:00:00+00', 'nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac', 48, 214);
INSERT INTO comment VALUES (292, '2017-12-11 00:00:00+00', 'interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis', 15, 81);
INSERT INTO comment VALUES (293, '2015-07-24 00:00:00+01', 'pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh', 9, 71);
INSERT INTO comment VALUES (294, '2016-10-23 00:00:00+01', 'luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus', 59, 210);
INSERT INTO comment VALUES (295, '2017-12-29 00:00:00+00', 'primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere', 87, 204);
INSERT INTO comment VALUES (296, '2016-11-24 00:00:00+00', 'risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate', 33, 297);
INSERT INTO comment VALUES (297, '2016-07-27 00:00:00+01', 'sit amet diam in magna bibendum imperdiet', 36, 260);
INSERT INTO comment VALUES (298, '2017-03-23 00:00:00+00', 'feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea', 68, 191);
INSERT INTO comment VALUES (299, '2015-10-22 00:00:00+01', 'nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo', 50, 31);
INSERT INTO comment VALUES (300, '2017-11-25 00:00:00+00', 'curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor', 9, 117);
INSERT INTO comment VALUES (301, '2015-07-07 00:00:00+01', 'purus phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor quis', 46, 208);
INSERT INTO comment VALUES (302, '2017-02-14 00:00:00+00', 'quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras', 93, 140);
INSERT INTO comment VALUES (303, '2016-07-19 00:00:00+01', 'nulla eget eros elementum pellentesque quisque porta volutpat erat', 74, 227);
INSERT INTO comment VALUES (304, '2018-01-13 00:00:00+00', 'habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer', 74, 142);
INSERT INTO comment VALUES (305, '2015-08-07 00:00:00+01', 'suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien', 42, 68);
INSERT INTO comment VALUES (306, '2017-11-12 00:00:00+00', 'elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing', 94, 261);
INSERT INTO comment VALUES (307, '2017-10-08 00:00:00+01', 'molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent', 16, 38);
INSERT INTO comment VALUES (308, '2017-08-13 00:00:00+01', 'est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis', 88, 121);
INSERT INTO comment VALUES (309, '2015-10-08 00:00:00+01', 'id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc', 66, 49);
INSERT INTO comment VALUES (310, '2018-01-18 00:00:00+00', 'sit amet sem fusce consequat nulla nisl nunc nisl duis', 84, 45);
INSERT INTO comment VALUES (311, '2015-12-20 00:00:00+00', 'nulla quisque arcu libero rutrum ac lobortis vel', 11, 189);
INSERT INTO comment VALUES (312, '2016-01-29 00:00:00+00', 'cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel', 89, 50);
INSERT INTO comment VALUES (313, '2017-03-25 00:00:00+00', 'ultrices aliquet maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat', 75, 131);
INSERT INTO comment VALUES (314, '2015-11-23 00:00:00+00', 'in porttitor pede justo eu massa donec dapibus duis at velit eu', 11, 300);
INSERT INTO comment VALUES (315, '2016-06-04 00:00:00+01', 'vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec', 97, 137);
INSERT INTO comment VALUES (316, '2015-03-22 00:00:00+00', 'hac habitasse platea', 45, 270);
INSERT INTO comment VALUES (317, '2016-05-04 00:00:00+01', 'cursus urna ut tellus nulla ut erat id mauris vulputate elementum', 5, 270);
INSERT INTO comment VALUES (318, '2016-11-20 00:00:00+00', 'ut blandit non interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel', 63, 44);
INSERT INTO comment VALUES (319, '2016-06-05 00:00:00+01', 'amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue', 20, 177);
INSERT INTO comment VALUES (320, '2015-03-20 00:00:00+00', 'vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor', 18, 293);
INSERT INTO comment VALUES (321, '2016-11-01 00:00:00+00', 'dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede', 4, 27);
INSERT INTO comment VALUES (322, '2017-09-06 00:00:00+01', 'felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam', 17, 247);
INSERT INTO comment VALUES (323, '2016-08-22 00:00:00+01', 'quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac', 76, 15);
INSERT INTO comment VALUES (324, '2016-02-16 00:00:00+00', 'metus aenean fermentum donec', 18, 212);
INSERT INTO comment VALUES (325, '2017-01-22 00:00:00+00', 'ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris', 92, 148);
INSERT INTO comment VALUES (326, '2015-05-16 00:00:00+01', 'eros viverra eget congue eget', 40, 239);
INSERT INTO comment VALUES (327, '2016-09-14 00:00:00+01', 'faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor vel est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien', 43, 277);
INSERT INTO comment VALUES (328, '2016-12-29 00:00:00+00', 'tempus sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id', 59, 27);
INSERT INTO comment VALUES (329, '2017-02-28 00:00:00+00', 'quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus', 11, 271);
INSERT INTO comment VALUES (330, '2017-09-15 00:00:00+01', 'eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin', 21, 96);
INSERT INTO comment VALUES (331, '2016-03-03 00:00:00+00', 'ac diam cras pellentesque volutpat dui maecenas', 98, 171);
INSERT INTO comment VALUES (332, '2017-06-16 00:00:00+01', 'vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum', 65, 59);
INSERT INTO comment VALUES (333, '2018-02-24 00:00:00+00', 'non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus', 84, 17);
INSERT INTO comment VALUES (334, '2017-11-22 00:00:00+00', 'blandit lacinia erat vestibulum sed magna at nunc commodo placerat', 96, 172);
INSERT INTO comment VALUES (335, '2016-03-08 00:00:00+00', 'eu massa donec dapibus duis at velit eu est congue elementum in', 22, 13);
INSERT INTO comment VALUES (336, '2016-10-10 00:00:00+01', 'velit vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui proin', 28, 194);
INSERT INTO comment VALUES (337, '2016-01-02 00:00:00+00', 'posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh', 8, 128);
INSERT INTO comment VALUES (338, '2017-07-07 00:00:00+01', 'lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia', 93, 288);
INSERT INTO comment VALUES (339, '2018-01-31 00:00:00+00', 'est et tempus semper est quam pharetra magna ac consequat', 6, 215);
INSERT INTO comment VALUES (340, '2015-05-12 00:00:00+01', 'dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio', 5, 24);
INSERT INTO comment VALUES (447, '2017-06-13 00:00:00+01', 'enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan', 80, 89);
INSERT INTO comment VALUES (341, '2017-01-30 00:00:00+00', 'sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi', 34, 23);
INSERT INTO comment VALUES (342, '2015-03-29 00:00:00+00', 'eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod', 24, 71);
INSERT INTO comment VALUES (343, '2015-12-15 00:00:00+00', 'ipsum dolor sit amet consectetuer adipiscing elit proin risus praesent lectus vestibulum quam', 35, 11);
INSERT INTO comment VALUES (344, '2017-10-29 00:00:00+01', 'maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt', 69, 85);
INSERT INTO comment VALUES (345, '2016-05-27 00:00:00+01', 'fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet', 10, 178);
INSERT INTO comment VALUES (346, '2016-10-19 00:00:00+01', 'in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula', 12, 8);
INSERT INTO comment VALUES (347, '2017-12-11 00:00:00+00', 'ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla', 27, 50);
INSERT INTO comment VALUES (348, '2016-10-21 00:00:00+01', 'consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id', 4, 281);
INSERT INTO comment VALUES (349, '2016-05-15 00:00:00+01', 'justo pellentesque viverra pede ac', 3, 249);
INSERT INTO comment VALUES (350, '2018-02-28 00:00:00+00', 'sapien arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus', 32, 151);
INSERT INTO comment VALUES (351, '2015-12-31 00:00:00+00', 'aliquam convallis nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec', 14, 46);
INSERT INTO comment VALUES (352, '2017-06-06 00:00:00+01', 'amet lobortis', 17, 6);
INSERT INTO comment VALUES (353, '2017-08-24 00:00:00+01', 'lacus morbi', 73, 59);
INSERT INTO comment VALUES (354, '2018-01-24 00:00:00+00', 'morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus', 36, 112);
INSERT INTO comment VALUES (355, '2018-03-03 00:00:00+00', 'nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio condimentum id luctus nec', 76, 131);
INSERT INTO comment VALUES (356, '2016-06-05 00:00:00+01', 'mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla', 49, 187);
INSERT INTO comment VALUES (357, '2015-06-27 00:00:00+01', 'ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non', 22, 172);
INSERT INTO comment VALUES (358, '2017-05-12 00:00:00+01', 'nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh', 65, 46);
INSERT INTO comment VALUES (359, '2017-10-19 00:00:00+01', 'justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus vel nulla eget', 87, 11);
INSERT INTO comment VALUES (360, '2017-08-24 00:00:00+01', 'nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis', 47, 46);
INSERT INTO comment VALUES (361, '2015-10-14 00:00:00+01', 'fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla', 71, 104);
INSERT INTO comment VALUES (362, '2017-09-23 00:00:00+01', 'habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi', 6, 162);
INSERT INTO comment VALUES (363, '2017-11-23 00:00:00+00', 'quisque porta volutpat erat quisque erat eros viverra eget congue eget semper', 69, 4);
INSERT INTO comment VALUES (364, '2017-06-26 00:00:00+01', 'curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis', 5, 249);
INSERT INTO comment VALUES (365, '2016-12-16 00:00:00+00', 'duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu', 6, 120);
INSERT INTO comment VALUES (366, '2016-08-21 00:00:00+01', 'interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel', 34, 208);
INSERT INTO comment VALUES (367, '2015-07-26 00:00:00+01', 'ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna', 40, 196);
INSERT INTO comment VALUES (368, '2016-09-08 00:00:00+01', 'integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed', 93, 284);
INSERT INTO comment VALUES (369, '2018-02-03 00:00:00+00', 'consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in', 89, 164);
INSERT INTO comment VALUES (370, '2015-07-06 00:00:00+01', 'elementum pellentesque quisque porta volutpat erat quisque erat eros viverra', 87, 169);
INSERT INTO comment VALUES (371, '2016-03-08 00:00:00+00', 'cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus', 45, 125);
INSERT INTO comment VALUES (372, '2015-12-26 00:00:00+00', 'quisque arcu libero rutrum ac lobortis', 43, 224);
INSERT INTO comment VALUES (373, '2017-03-07 00:00:00+00', 'erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum', 72, 51);
INSERT INTO comment VALUES (374, '2016-06-25 00:00:00+01', 'odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia', 12, 65);
INSERT INTO comment VALUES (375, '2017-09-24 00:00:00+01', 'quis turpis eget elit sodales scelerisque mauris', 63, 136);
INSERT INTO comment VALUES (407, '2015-09-23 00:00:00+01', 'mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante', 16, 99);
INSERT INTO comment VALUES (376, '2015-07-21 00:00:00+01', 'at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam', 28, 41);
INSERT INTO comment VALUES (377, '2017-06-22 00:00:00+01', 'nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut', 70, 123);
INSERT INTO comment VALUES (378, '2016-07-13 00:00:00+01', 'quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque', 32, 81);
INSERT INTO comment VALUES (379, '2016-11-12 00:00:00+00', 'ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien', 99, 71);
INSERT INTO comment VALUES (380, '2015-05-01 00:00:00+01', 'pellentesque at nulla suspendisse potenti cras in purus eu', 1, 216);
INSERT INTO comment VALUES (381, '2017-06-26 00:00:00+01', 'id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus', 92, 159);
INSERT INTO comment VALUES (382, '2016-05-18 00:00:00+01', 'pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec', 97, 47);
INSERT INTO comment VALUES (383, '2017-01-12 00:00:00+00', 'in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus', 99, 59);
INSERT INTO comment VALUES (384, '2017-08-06 00:00:00+01', 'quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna', 9, 288);
INSERT INTO comment VALUES (385, '2016-11-22 00:00:00+00', 'nam congue risus semper porta volutpat quam pede lobortis ligula', 85, 103);
INSERT INTO comment VALUES (386, '2017-01-29 00:00:00+00', 'nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer', 68, 167);
INSERT INTO comment VALUES (387, '2015-05-31 00:00:00+01', 'non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede', 90, 22);
INSERT INTO comment VALUES (388, '2018-01-19 00:00:00+00', 'nisl nunc nisl duis bibendum felis sed interdum venenatis', 20, 35);
INSERT INTO comment VALUES (389, '2015-06-05 00:00:00+01', 'diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu', 13, 205);
INSERT INTO comment VALUES (390, '2016-09-18 00:00:00+01', 'et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce', 13, 131);
INSERT INTO comment VALUES (391, '2016-06-03 00:00:00+01', 'euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate', 53, 292);
INSERT INTO comment VALUES (392, '2015-04-02 00:00:00+01', 'ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur', 62, 141);
INSERT INTO comment VALUES (393, '2015-12-05 00:00:00+00', 'eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere', 13, 160);
INSERT INTO comment VALUES (394, '2017-12-19 00:00:00+00', 'accumsan tellus nisi eu orci mauris lacinia sapien quis libero', 12, 275);
INSERT INTO comment VALUES (395, '2016-08-31 00:00:00+01', 'at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus', 67, 95);
INSERT INTO comment VALUES (396, '2016-12-14 00:00:00+00', 'duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus', 96, 154);
INSERT INTO comment VALUES (397, '2016-04-27 00:00:00+01', 'nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam', 57, 96);
INSERT INTO comment VALUES (398, '2015-09-11 00:00:00+01', 'orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam', 14, 19);
INSERT INTO comment VALUES (399, '2017-07-17 00:00:00+01', 'sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci', 69, 22);
INSERT INTO comment VALUES (400, '2017-09-11 00:00:00+01', 'ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis', 28, 12);
INSERT INTO comment VALUES (401, '2015-08-17 00:00:00+01', 'vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor', 38, 109);
INSERT INTO comment VALUES (402, '2015-10-15 00:00:00+01', 'pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam', 59, 249);
INSERT INTO comment VALUES (403, '2018-01-16 00:00:00+00', 'augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel dapibus at', 75, 134);
INSERT INTO comment VALUES (404, '2016-02-20 00:00:00+00', 'ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse', 37, 72);
INSERT INTO comment VALUES (405, '2017-10-01 00:00:00+01', 'dapibus dolor vel est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue', 55, 277);
INSERT INTO comment VALUES (406, '2016-11-17 00:00:00+00', 'neque sapien placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu', 52, 248);
INSERT INTO comment VALUES (408, '2016-02-29 00:00:00+00', 'morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta', 26, 86);
INSERT INTO comment VALUES (409, '2016-07-22 00:00:00+01', 'proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl', 26, 291);
INSERT INTO comment VALUES (410, '2016-08-31 00:00:00+01', 'magnis dis parturient montes nascetur ridiculus mus', 61, 157);
INSERT INTO comment VALUES (411, '2016-06-30 00:00:00+01', 'eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor vel est donec odio justo sollicitudin ut suscipit a feugiat et eros', 77, 209);
INSERT INTO comment VALUES (412, '2015-05-12 00:00:00+01', 'dui luctus rutrum nulla tellus in', 67, 159);
INSERT INTO comment VALUES (413, '2017-05-31 00:00:00+01', 'turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu', 95, 188);
INSERT INTO comment VALUES (414, '2015-10-28 00:00:00+00', 'dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper', 57, 59);
INSERT INTO comment VALUES (415, '2016-11-06 00:00:00+00', 'in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum', 70, 271);
INSERT INTO comment VALUES (416, '2016-07-07 00:00:00+01', 'nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut', 57, 259);
INSERT INTO comment VALUES (417, '2017-04-18 00:00:00+01', 'tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo', 16, 128);
INSERT INTO comment VALUES (418, '2018-02-06 00:00:00+00', 'vel nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in', 5, 145);
INSERT INTO comment VALUES (419, '2016-08-09 00:00:00+01', 'elementum ligula vehicula', 29, 5);
INSERT INTO comment VALUES (420, '2017-08-28 00:00:00+01', 'eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus', 98, 47);
INSERT INTO comment VALUES (421, '2017-07-16 00:00:00+01', 'turpis elementum ligula', 32, 199);
INSERT INTO comment VALUES (422, '2018-01-18 00:00:00+00', 'ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl', 26, 63);
INSERT INTO comment VALUES (423, '2016-09-27 00:00:00+01', 'pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam', 18, 62);
INSERT INTO comment VALUES (424, '2018-02-28 00:00:00+00', 'massa donec dapibus', 45, 117);
INSERT INTO comment VALUES (425, '2017-11-21 00:00:00+00', 'ultrices vel augue vestibulum', 27, 14);
INSERT INTO comment VALUES (426, '2015-10-04 00:00:00+01', 'in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula', 39, 294);
INSERT INTO comment VALUES (427, '2015-06-20 00:00:00+01', 'nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed', 81, 30);
INSERT INTO comment VALUES (428, '2015-10-19 00:00:00+01', 'fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo', 97, 84);
INSERT INTO comment VALUES (429, '2015-06-03 00:00:00+01', 'nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque', 43, 141);
INSERT INTO comment VALUES (430, '2017-08-21 00:00:00+01', 'tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum', 68, 35);
INSERT INTO comment VALUES (431, '2016-05-09 00:00:00+01', 'ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut', 77, 272);
INSERT INTO comment VALUES (432, '2016-08-24 00:00:00+01', 'eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante', 10, 108);
INSERT INTO comment VALUES (433, '2016-08-20 00:00:00+01', 'sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi', 88, 150);
INSERT INTO comment VALUES (434, '2016-07-05 00:00:00+01', 'sit amet turpis elementum ligula vehicula consequat', 65, 64);
INSERT INTO comment VALUES (435, '2016-08-24 00:00:00+01', 'cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus', 45, 142);
INSERT INTO comment VALUES (436, '2015-08-29 00:00:00+01', 'pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae', 37, 192);
INSERT INTO comment VALUES (437, '2017-05-16 00:00:00+01', 'nibh in quis justo maecenas rhoncus', 77, 263);
INSERT INTO comment VALUES (438, '2015-08-24 00:00:00+01', 'justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci', 34, 252);
INSERT INTO comment VALUES (439, '2017-01-01 00:00:00+00', 'orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu', 18, 232);
INSERT INTO comment VALUES (440, '2016-02-06 00:00:00+00', 'montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet', 99, 87);
INSERT INTO comment VALUES (441, '2016-05-15 00:00:00+01', 'nulla ac enim in tempor turpis', 19, 138);
INSERT INTO comment VALUES (442, '2018-01-28 00:00:00+00', 'potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet', 10, 272);
INSERT INTO comment VALUES (443, '2016-06-01 00:00:00+01', 'primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non', 68, 8);
INSERT INTO comment VALUES (495, '2018-01-13 00:00:00+00', 'aenean lectus pellentesque eget', 46, 92);
INSERT INTO comment VALUES (448, '2017-05-01 00:00:00+01', 'lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum', 6, 104);
INSERT INTO comment VALUES (449, '2017-09-26 00:00:00+01', 'penatibus et', 67, 137);
INSERT INTO comment VALUES (450, '2016-07-09 00:00:00+01', 'et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis', 99, 225);
INSERT INTO comment VALUES (451, '2015-10-10 00:00:00+01', 'sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet', 67, 66);
INSERT INTO comment VALUES (452, '2017-12-10 00:00:00+00', 'ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio', 38, 166);
INSERT INTO comment VALUES (453, '2016-12-30 00:00:00+00', 'ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien', 97, 154);
INSERT INTO comment VALUES (454, '2017-01-08 00:00:00+00', 'fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla', 81, 255);
INSERT INTO comment VALUES (455, '2016-06-17 00:00:00+01', 'justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor', 20, 153);
INSERT INTO comment VALUES (456, '2016-12-10 00:00:00+00', 'sed sagittis', 65, 56);
INSERT INTO comment VALUES (457, '2017-01-11 00:00:00+00', 'habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam', 61, 142);
INSERT INTO comment VALUES (458, '2017-09-25 00:00:00+01', 'nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula', 45, 165);
INSERT INTO comment VALUES (459, '2017-01-10 00:00:00+00', 'posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam', 82, 270);
INSERT INTO comment VALUES (460, '2016-08-16 00:00:00+01', 'justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet sem fusce consequat nulla nisl nunc', 54, 300);
INSERT INTO comment VALUES (461, '2016-06-04 00:00:00+01', 'ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam', 85, 280);
INSERT INTO comment VALUES (462, '2018-02-19 00:00:00+00', 'posuere cubilia curae nulla dapibus dolor', 9, 228);
INSERT INTO comment VALUES (463, '2015-04-18 00:00:00+01', 'rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend', 31, 224);
INSERT INTO comment VALUES (464, '2016-12-04 00:00:00+00', 'justo aliquam quis turpis eget', 17, 150);
INSERT INTO comment VALUES (465, '2016-08-12 00:00:00+01', 'eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis', 42, 273);
INSERT INTO comment VALUES (466, '2018-03-03 00:00:00+00', 'primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut', 45, 79);
INSERT INTO comment VALUES (467, '2017-04-27 00:00:00+01', 'morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue', 69, 267);
INSERT INTO comment VALUES (468, '2017-04-27 00:00:00+01', 'habitasse platea dictumst', 91, 43);
INSERT INTO comment VALUES (469, '2015-11-28 00:00:00+00', 'non ligula pellentesque ultrices phasellus', 92, 181);
INSERT INTO comment VALUES (470, '2015-05-04 00:00:00+01', 'sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum', 11, 27);
INSERT INTO comment VALUES (471, '2016-09-22 00:00:00+01', 'curabitur gravida nisi at nibh in hac habitasse', 90, 207);
INSERT INTO comment VALUES (472, '2017-08-21 00:00:00+01', 'ridiculus mus', 41, 164);
INSERT INTO comment VALUES (473, '2016-06-30 00:00:00+01', 'dictumst aliquam augue quam sollicitudin vitae consectetuer', 92, 44);
INSERT INTO comment VALUES (474, '2017-01-27 00:00:00+00', 'adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere nonummy integer', 20, 222);
INSERT INTO comment VALUES (475, '2015-08-03 00:00:00+01', 'dui', 63, 105);
INSERT INTO comment VALUES (476, '2016-12-07 00:00:00+00', 'vel dapibus at diam', 85, 124);
INSERT INTO comment VALUES (477, '2018-02-01 00:00:00+00', 'amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio condimentum id luctus nec molestie', 94, 113);
INSERT INTO comment VALUES (478, '2016-01-08 00:00:00+00', 'potenti cras in purus eu magna vulputate luctus cum sociis natoque', 43, 237);
INSERT INTO comment VALUES (479, '2017-09-22 00:00:00+01', 'pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet sem fusce consequat nulla nisl', 62, 174);
INSERT INTO comment VALUES (480, '2017-08-06 00:00:00+01', 'congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien', 34, 255);
INSERT INTO comment VALUES (481, '2015-11-26 00:00:00+00', 'turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis', 55, 161);
INSERT INTO comment VALUES (482, '2016-02-05 00:00:00+00', 'mauris', 81, 177);
INSERT INTO comment VALUES (483, '2018-03-04 00:00:00+00', 'a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris', 51, 105);
INSERT INTO comment VALUES (484, '2015-10-05 00:00:00+01', 'sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula', 95, 223);
INSERT INTO comment VALUES (485, '2016-01-23 00:00:00+00', 'faucibus orci luctus et ultrices', 44, 167);
INSERT INTO comment VALUES (486, '2017-01-01 00:00:00+00', 'arcu', 89, 164);
INSERT INTO comment VALUES (487, '2015-11-18 00:00:00+00', 'consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in', 53, 266);
INSERT INTO comment VALUES (488, '2015-07-12 00:00:00+01', 'venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque', 15, 37);
INSERT INTO comment VALUES (489, '2018-02-04 00:00:00+00', 'posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel', 92, 49);
INSERT INTO comment VALUES (490, '2015-06-18 00:00:00+01', 'arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci', 19, 169);
INSERT INTO comment VALUES (491, '2015-12-24 00:00:00+00', 'blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus', 57, 98);
INSERT INTO comment VALUES (492, '2015-07-21 00:00:00+01', 'penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis', 40, 31);
INSERT INTO comment VALUES (493, '2016-05-07 00:00:00+01', 'semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at', 100, 65);
INSERT INTO comment VALUES (494, '2016-06-24 00:00:00+01', 'ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti', 17, 183);
INSERT INTO comment VALUES (496, '2016-03-20 00:00:00+00', 'suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus', 58, 296);
INSERT INTO comment VALUES (497, '2016-01-10 00:00:00+00', 'vestibulum rutrum rutrum neque aenean', 31, 271);
INSERT INTO comment VALUES (498, '2015-07-08 00:00:00+01', 'tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante', 79, 279);
INSERT INTO comment VALUES (499, '2017-05-29 00:00:00+01', 'orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio', 29, 195);
INSERT INTO comment VALUES (500, '2015-12-14 00:00:00+00', 'maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in', 88, 128);
INSERT INTO comment VALUES (501, '2017-06-16 00:00:00+01', 'eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem', 79, 243);
INSERT INTO comment VALUES (502, '2015-08-19 00:00:00+01', 'posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non', 68, 167);
INSERT INTO comment VALUES (503, '2015-07-19 00:00:00+01', 'sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie', 41, 73);
INSERT INTO comment VALUES (504, '2015-07-20 00:00:00+01', 'integer non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna', 18, 235);
INSERT INTO comment VALUES (505, '2016-05-13 00:00:00+01', 'sapien sapien non mi integer ac neque duis bibendum morbi non quam nec', 56, 142);
INSERT INTO comment VALUES (506, '2017-09-17 00:00:00+01', 'eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum', 77, 189);
INSERT INTO comment VALUES (507, '2015-08-31 00:00:00+01', 'lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo', 59, 105);
INSERT INTO comment VALUES (508, '2016-05-08 00:00:00+01', 'vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet sem fusce consequat nulla nisl', 32, 200);
INSERT INTO comment VALUES (509, '2016-01-18 00:00:00+00', 'pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus', 83, 148);
INSERT INTO comment VALUES (510, '2015-06-30 00:00:00+01', 'etiam faucibus cursus urna ut tellus nulla ut erat id mauris', 27, 186);
INSERT INTO comment VALUES (511, '2017-06-15 00:00:00+01', 'duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat non', 45, 197);
INSERT INTO comment VALUES (512, '2017-12-21 00:00:00+00', 'dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim', 61, 149);
INSERT INTO comment VALUES (513, '2016-01-22 00:00:00+00', 'placerat praesent blandit nam nulla', 94, 183);
INSERT INTO comment VALUES (514, '2016-12-17 00:00:00+00', 'vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit', 46, 54);
INSERT INTO comment VALUES (515, '2015-06-30 00:00:00+01', 'vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices vel', 86, 150);
INSERT INTO comment VALUES (516, '2017-04-30 00:00:00+01', 'ut massa quis', 56, 198);
INSERT INTO comment VALUES (517, '2016-07-19 00:00:00+01', 'phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem', 6, 44);
INSERT INTO comment VALUES (518, '2017-02-07 00:00:00+00', 'justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra', 97, 26);
INSERT INTO comment VALUES (519, '2017-01-05 00:00:00+00', 'sapien', 7, 205);
INSERT INTO comment VALUES (520, '2015-06-20 00:00:00+01', 'vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris', 19, 131);
INSERT INTO comment VALUES (521, '2017-06-05 00:00:00+01', 'nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet', 25, 230);
INSERT INTO comment VALUES (522, '2017-01-31 00:00:00+00', 'luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices', 65, 181);
INSERT INTO comment VALUES (523, '2017-11-14 00:00:00+00', 'amet', 60, 212);
INSERT INTO comment VALUES (524, '2018-02-15 00:00:00+00', 'in felis eu sapien cursus vestibulum proin eu mi', 61, 81);
INSERT INTO comment VALUES (525, '2016-01-22 00:00:00+00', 'maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac diam', 15, 8);
INSERT INTO comment VALUES (526, '2016-07-22 00:00:00+01', 'condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget', 31, 151);
INSERT INTO comment VALUES (527, '2016-02-16 00:00:00+00', 'odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium', 30, 280);
INSERT INTO comment VALUES (528, '2016-02-21 00:00:00+00', 'suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque', 74, 223);
INSERT INTO comment VALUES (529, '2018-03-18 00:00:00+00', 'velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum', 81, 4);
INSERT INTO comment VALUES (530, '2017-04-16 00:00:00+01', 'dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend', 62, 124);
INSERT INTO comment VALUES (531, '2016-11-10 00:00:00+00', 'praesent blandit lacinia erat vestibulum sed magna at nunc', 64, 123);
INSERT INTO comment VALUES (532, '2017-08-28 00:00:00+01', 'nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat', 12, 142);
INSERT INTO comment VALUES (533, '2018-01-26 00:00:00+00', 'nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum', 25, 269);
INSERT INTO comment VALUES (534, '2017-10-19 00:00:00+01', 'justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa', 63, 32);
INSERT INTO comment VALUES (535, '2018-01-27 00:00:00+00', 'ut massa quis augue luctus', 45, 68);
INSERT INTO comment VALUES (536, '2016-07-23 00:00:00+01', 'ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non', 11, 272);
INSERT INTO comment VALUES (537, '2016-12-28 00:00:00+00', 'leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis', 50, 143);
INSERT INTO comment VALUES (538, '2015-11-09 00:00:00+00', 'ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui', 21, 258);
INSERT INTO comment VALUES (539, '2015-03-29 00:00:00+00', 'ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet', 6, 63);
INSERT INTO comment VALUES (540, '2017-03-14 00:00:00+00', 'cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc', 44, 217);
INSERT INTO comment VALUES (541, '2016-05-16 00:00:00+01', 'sem duis aliquam convallis nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat', 65, 283);
INSERT INTO comment VALUES (542, '2017-04-08 00:00:00+01', 'amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu', 92, 142);
INSERT INTO comment VALUES (543, '2016-01-11 00:00:00+00', 'nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque', 10, 105);
INSERT INTO comment VALUES (544, '2016-04-07 00:00:00+01', 'mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas', 59, 278);
INSERT INTO comment VALUES (545, '2015-12-02 00:00:00+00', 'libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras', 5, 124);
INSERT INTO comment VALUES (546, '2016-09-30 00:00:00+01', 'id luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam', 14, 69);
INSERT INTO comment VALUES (547, '2017-01-04 00:00:00+00', 'ultrices posuere cubilia curae donec pharetra magna', 70, 245);
INSERT INTO comment VALUES (548, '2017-03-16 00:00:00+00', 'quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede', 88, 260);
INSERT INTO comment VALUES (549, '2016-06-25 00:00:00+01', 'faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan', 40, 152);
INSERT INTO comment VALUES (550, '2017-02-19 00:00:00+00', 'justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue', 8, 189);
INSERT INTO comment VALUES (551, '2016-08-19 00:00:00+01', 'cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem', 18, 57);
INSERT INTO comment VALUES (552, '2016-07-27 00:00:00+01', 'eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla', 47, 204);
INSERT INTO comment VALUES (553, '2015-08-04 00:00:00+01', 'sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi', 78, 216);
INSERT INTO comment VALUES (554, '2015-09-07 00:00:00+01', 'duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse', 17, 274);
INSERT INTO comment VALUES (555, '2018-01-12 00:00:00+00', 'molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus', 21, 243);
INSERT INTO comment VALUES (556, '2017-05-19 00:00:00+01', 'justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla', 63, 4);
INSERT INTO comment VALUES (557, '2016-01-16 00:00:00+00', 'dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie', 27, 123);
INSERT INTO comment VALUES (558, '2017-10-09 00:00:00+01', 'velit vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam', 70, 24);
INSERT INTO comment VALUES (559, '2017-06-16 00:00:00+01', 'aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula', 96, 283);
INSERT INTO comment VALUES (560, '2017-09-25 00:00:00+01', 'quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus', 71, 163);
INSERT INTO comment VALUES (561, '2016-09-03 00:00:00+01', 'dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras', 22, 145);
INSERT INTO comment VALUES (562, '2016-09-23 00:00:00+01', 'est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium', 35, 256);
INSERT INTO comment VALUES (563, '2017-11-13 00:00:00+00', 'odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum', 74, 290);
INSERT INTO comment VALUES (564, '2015-05-08 00:00:00+01', 'augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam', 75, 138);
INSERT INTO comment VALUES (565, '2016-09-02 00:00:00+01', 'at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis', 25, 14);
INSERT INTO comment VALUES (566, '2015-08-30 00:00:00+01', 'gravida sem praesent id massa id', 34, 293);
INSERT INTO comment VALUES (567, '2015-12-02 00:00:00+00', 'vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar', 27, 165);
INSERT INTO comment VALUES (568, '2016-10-04 00:00:00+01', 'elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel dapibus at diam nam tristique tortor eu pede', 8, 214);
INSERT INTO comment VALUES (569, '2016-05-12 00:00:00+01', 'tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum', 74, 61);
INSERT INTO comment VALUES (570, '2016-03-13 00:00:00+00', 'eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla', 39, 82);
INSERT INTO comment VALUES (571, '2017-05-15 00:00:00+01', 'augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id', 100, 151);
INSERT INTO comment VALUES (572, '2017-03-12 00:00:00+00', 'semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel dapibus at', 69, 1);
INSERT INTO comment VALUES (573, '2016-06-23 00:00:00+01', 'nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est', 73, 82);
INSERT INTO comment VALUES (574, '2016-07-03 00:00:00+01', 'tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum', 66, 2);
INSERT INTO comment VALUES (575, '2017-07-13 00:00:00+01', 'sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum', 26, 68);
INSERT INTO comment VALUES (576, '2015-12-09 00:00:00+00', 'rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu', 74, 283);
INSERT INTO comment VALUES (577, '2015-04-02 00:00:00+01', 'augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum', 29, 232);
INSERT INTO comment VALUES (578, '2017-05-03 00:00:00+01', 'tempus semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et', 88, 294);
INSERT INTO comment VALUES (579, '2015-03-30 00:00:00+01', 'sit amet erat nulla tempus', 17, 257);
INSERT INTO comment VALUES (580, '2015-07-25 00:00:00+01', 'ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien', 50, 298);
INSERT INTO comment VALUES (581, '2016-01-30 00:00:00+00', 'posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet', 85, 78);
INSERT INTO comment VALUES (582, '2015-11-04 00:00:00+00', 'pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo', 48, 24);
INSERT INTO comment VALUES (583, '2015-06-05 00:00:00+01', 'est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue', 63, 64);
INSERT INTO comment VALUES (584, '2017-10-24 00:00:00+01', 'pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id', 24, 202);
INSERT INTO comment VALUES (585, '2015-07-16 00:00:00+01', 'mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae nulla', 23, 197);
INSERT INTO comment VALUES (586, '2015-10-31 00:00:00+00', 'ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra', 96, 140);
INSERT INTO comment VALUES (587, '2016-11-13 00:00:00+00', 'condimentum id luctus nec', 95, 114);
INSERT INTO comment VALUES (588, '2017-06-22 00:00:00+01', 'interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit', 23, 36);
INSERT INTO comment VALUES (589, '2015-10-19 00:00:00+01', 'pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut', 7, 48);
INSERT INTO comment VALUES (590, '2018-02-12 00:00:00+00', 'platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt', 73, 271);
INSERT INTO comment VALUES (591, '2017-08-08 00:00:00+01', 'mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus', 11, 32);
INSERT INTO comment VALUES (592, '2016-08-03 00:00:00+01', 'cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida', 94, 45);
INSERT INTO comment VALUES (593, '2017-09-15 00:00:00+01', 'ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien', 11, 285);
INSERT INTO comment VALUES (594, '2017-12-13 00:00:00+00', 'proin risus praesent lectus vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam', 88, 153);
INSERT INTO comment VALUES (595, '2016-10-20 00:00:00+01', 'tempor turpis nec euismod', 27, 193);
INSERT INTO comment VALUES (596, '2015-11-08 00:00:00+00', 'est lacinia nisi venenatis tristique fusce congue', 75, 44);
INSERT INTO comment VALUES (597, '2016-03-14 00:00:00+00', 'curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor', 56, 254);
INSERT INTO comment VALUES (598, '2017-05-14 00:00:00+01', 'integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis', 98, 189);
INSERT INTO comment VALUES (599, '2017-04-20 00:00:00+01', 'sapien a libero nam dui proin', 4, 28);
INSERT INTO comment VALUES (600, '2017-11-27 00:00:00+00', 'nibh in lectus pellentesque at nulla suspendisse potenti', 92, 230);
INSERT INTO comment VALUES (601, '2017-05-06 00:00:00+01', 'nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi', 19, 183);
INSERT INTO comment VALUES (602, '2017-10-19 00:00:00+01', 'fusce consequat nulla nisl nunc nisl duis bibendum', 99, 240);
INSERT INTO comment VALUES (603, '2015-04-20 00:00:00+01', 'ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper', 31, 240);
INSERT INTO comment VALUES (604, '2017-01-25 00:00:00+00', 'nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere', 20, 174);
INSERT INTO comment VALUES (674, '2017-03-19 00:00:00+00', 'vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor vel est donec odio justo', 67, 30);
INSERT INTO comment VALUES (605, '2016-05-30 00:00:00+01', 'leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue', 6, 31);
INSERT INTO comment VALUES (606, '2015-11-16 00:00:00+00', 'orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis', 86, 141);
INSERT INTO comment VALUES (607, '2015-06-05 00:00:00+01', 'mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse', 10, 14);
INSERT INTO comment VALUES (608, '2017-11-15 00:00:00+00', 'ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus', 35, 237);
INSERT INTO comment VALUES (609, '2015-08-24 00:00:00+01', 'consequat lectus in est risus auctor sed tristique in tempus sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa', 68, 184);
INSERT INTO comment VALUES (610, '2017-06-29 00:00:00+01', 'justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et', 95, 2);
INSERT INTO comment VALUES (611, '2016-09-27 00:00:00+01', 'ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat', 5, 201);
INSERT INTO comment VALUES (612, '2017-12-04 00:00:00+00', 'faucibus cursus urna ut tellus nulla ut erat id mauris vulputate', 39, 113);
INSERT INTO comment VALUES (613, '2016-09-24 00:00:00+01', 'porta volutpat erat quisque erat eros viverra', 92, 25);
INSERT INTO comment VALUES (614, '2018-01-26 00:00:00+00', 'elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget', 44, 217);
INSERT INTO comment VALUES (615, '2016-04-08 00:00:00+01', 'dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient', 6, 90);
INSERT INTO comment VALUES (616, '2018-03-11 00:00:00+00', 'consectetuer adipiscing elit proin risus praesent lectus vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi', 50, 35);
INSERT INTO comment VALUES (617, '2017-09-02 00:00:00+01', 'mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie', 15, 189);
INSERT INTO comment VALUES (618, '2016-08-16 00:00:00+01', 'sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu', 14, 213);
INSERT INTO comment VALUES (619, '2017-06-21 00:00:00+01', 'vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla', 36, 125);
INSERT INTO comment VALUES (620, '2016-05-26 00:00:00+01', 'sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate', 34, 287);
INSERT INTO comment VALUES (621, '2016-10-03 00:00:00+01', 'amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis', 33, 163);
INSERT INTO comment VALUES (622, '2017-07-24 00:00:00+01', 'ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel dapibus at diam nam tristique tortor eu', 17, 200);
INSERT INTO comment VALUES (623, '2017-11-02 00:00:00+00', 'rutrum rutrum neque aenean auctor gravida sem praesent id massa', 36, 118);
INSERT INTO comment VALUES (624, '2016-02-29 00:00:00+00', 'ultrices posuere cubilia curae mauris viverra diam', 87, 107);
INSERT INTO comment VALUES (625, '2015-11-22 00:00:00+00', 'pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec', 93, 255);
INSERT INTO comment VALUES (626, '2017-07-30 00:00:00+01', 'amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum', 13, 114);
INSERT INTO comment VALUES (627, '2017-03-09 00:00:00+00', 'interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in', 91, 283);
INSERT INTO comment VALUES (628, '2017-10-18 00:00:00+01', 'pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis', 19, 82);
INSERT INTO comment VALUES (629, '2016-05-06 00:00:00+01', 'donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus', 37, 276);
INSERT INTO comment VALUES (630, '2016-05-01 00:00:00+01', 'et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet', 39, 66);
INSERT INTO comment VALUES (631, '2015-08-11 00:00:00+01', 'morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla', 83, 102);
INSERT INTO comment VALUES (632, '2017-04-07 00:00:00+01', 'arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in', 65, 71);
INSERT INTO comment VALUES (633, '2016-12-11 00:00:00+00', 'cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo odio', 16, 174);
INSERT INTO comment VALUES (634, '2016-04-02 00:00:00+01', 'arcu', 80, 244);
INSERT INTO comment VALUES (635, '2015-09-11 00:00:00+01', 'nullam molestie nibh in lectus pellentesque at', 87, 203);
INSERT INTO comment VALUES (636, '2017-03-28 00:00:00+01', 'porttitor pede', 59, 274);
INSERT INTO comment VALUES (637, '2016-07-26 00:00:00+01', 'est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante', 54, 43);
INSERT INTO comment VALUES (638, '2017-12-30 00:00:00+00', 'mauris laoreet ut', 5, 132);
INSERT INTO comment VALUES (639, '2017-07-23 00:00:00+01', 'consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis', 77, 80);
INSERT INTO comment VALUES (675, '2017-04-16 00:00:00+01', 'hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam', 77, 252);
INSERT INTO comment VALUES (640, '2015-12-13 00:00:00+00', 'hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat', 44, 110);
INSERT INTO comment VALUES (641, '2015-10-09 00:00:00+01', 'nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim', 25, 181);
INSERT INTO comment VALUES (642, '2017-03-21 00:00:00+00', 'sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui', 29, 220);
INSERT INTO comment VALUES (643, '2015-08-15 00:00:00+01', 'amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci', 49, 295);
INSERT INTO comment VALUES (644, '2016-10-10 00:00:00+01', 'quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus', 2, 90);
INSERT INTO comment VALUES (645, '2017-02-20 00:00:00+00', 'nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum', 32, 174);
INSERT INTO comment VALUES (646, '2017-07-24 00:00:00+01', 'nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel dapibus at diam', 55, 290);
INSERT INTO comment VALUES (647, '2016-05-24 00:00:00+01', 'convallis nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum', 15, 112);
INSERT INTO comment VALUES (648, '2016-03-13 00:00:00+00', 'rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem', 33, 241);
INSERT INTO comment VALUES (649, '2015-06-30 00:00:00+01', 'id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in', 39, 9);
INSERT INTO comment VALUES (650, '2017-08-31 00:00:00+01', 'odio elementum eu', 82, 172);
INSERT INTO comment VALUES (651, '2016-10-29 00:00:00+01', 'convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi', 14, 7);
INSERT INTO comment VALUES (652, '2017-11-12 00:00:00+00', 'blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim', 78, 176);
INSERT INTO comment VALUES (653, '2017-07-25 00:00:00+01', 'risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam', 2, 100);
INSERT INTO comment VALUES (654, '2017-03-13 00:00:00+00', 'turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo', 60, 48);
INSERT INTO comment VALUES (655, '2016-10-10 00:00:00+01', 'aliquet maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae', 82, 143);
INSERT INTO comment VALUES (656, '2018-01-02 00:00:00+00', 'donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae', 82, 241);
INSERT INTO comment VALUES (657, '2017-08-17 00:00:00+01', 'cras mi pede malesuada in imperdiet et commodo', 63, 114);
INSERT INTO comment VALUES (658, '2017-05-31 00:00:00+01', 'eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum', 75, 171);
INSERT INTO comment VALUES (659, '2016-05-24 00:00:00+01', 'sed tincidunt eu felis', 39, 280);
INSERT INTO comment VALUES (660, '2016-04-16 00:00:00+01', 'aliquet at feugiat', 44, 288);
INSERT INTO comment VALUES (661, '2017-06-14 00:00:00+01', 'nec nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam', 9, 124);
INSERT INTO comment VALUES (662, '2016-03-23 00:00:00+00', 'velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis', 5, 56);
INSERT INTO comment VALUES (663, '2017-06-24 00:00:00+01', 'ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit', 67, 206);
INSERT INTO comment VALUES (664, '2016-10-21 00:00:00+01', 'non ligula', 39, 164);
INSERT INTO comment VALUES (665, '2016-10-26 00:00:00+01', 'felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in', 86, 34);
INSERT INTO comment VALUES (666, '2015-04-01 00:00:00+01', 'vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in', 66, 146);
INSERT INTO comment VALUES (667, '2015-04-24 00:00:00+01', 'dui nec nisi volutpat', 77, 250);
INSERT INTO comment VALUES (668, '2016-03-24 00:00:00+00', 'turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum', 91, 151);
INSERT INTO comment VALUES (669, '2016-06-10 00:00:00+01', 'dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla', 63, 238);
INSERT INTO comment VALUES (670, '2017-03-24 00:00:00+00', 'vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa', 44, 42);
INSERT INTO comment VALUES (671, '2017-04-13 00:00:00+01', 'vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue', 5, 116);
INSERT INTO comment VALUES (672, '2015-10-17 00:00:00+01', 'gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin', 39, 157);
INSERT INTO comment VALUES (673, '2016-09-06 00:00:00+01', 'vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus', 63, 59);
INSERT INTO comment VALUES (676, '2017-03-23 00:00:00+00', 'quisque id justo sit amet sapien dignissim vestibulum vestibulum', 67, 134);
INSERT INTO comment VALUES (677, '2016-10-25 00:00:00+01', 'placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor', 17, 208);
INSERT INTO comment VALUES (678, '2017-04-07 00:00:00+01', 'blandit nam nulla integer pede', 63, 44);
INSERT INTO comment VALUES (679, '2016-08-27 00:00:00+01', 'orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer', 83, 211);
INSERT INTO comment VALUES (680, '2017-05-09 00:00:00+01', 'sit amet consectetuer adipiscing elit proin risus praesent lectus vestibulum quam sapien varius ut blandit non', 78, 271);
INSERT INTO comment VALUES (681, '2017-09-28 00:00:00+01', 'quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien', 99, 156);
INSERT INTO comment VALUES (682, '2016-07-02 00:00:00+01', 'in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas', 51, 39);
INSERT INTO comment VALUES (683, '2016-06-18 00:00:00+01', 'scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo', 74, 50);
INSERT INTO comment VALUES (684, '2017-07-01 00:00:00+01', 'dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue', 38, 246);
INSERT INTO comment VALUES (685, '2015-04-10 00:00:00+01', 'at', 98, 201);
INSERT INTO comment VALUES (686, '2015-05-25 00:00:00+01', 'quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis', 25, 145);
INSERT INTO comment VALUES (687, '2018-03-11 00:00:00+00', 'felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat', 28, 90);
INSERT INTO comment VALUES (688, '2015-12-14 00:00:00+00', 'nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem', 90, 25);
INSERT INTO comment VALUES (689, '2017-05-19 00:00:00+01', 'quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis', 68, 159);
INSERT INTO comment VALUES (690, '2016-01-19 00:00:00+00', 'hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id', 68, 11);
INSERT INTO comment VALUES (691, '2016-09-08 00:00:00+01', 'nibh ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci', 55, 209);
INSERT INTO comment VALUES (692, '2015-09-08 00:00:00+01', 'sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus', 62, 261);
INSERT INTO comment VALUES (693, '2016-11-22 00:00:00+00', 'neque libero convallis', 48, 202);
INSERT INTO comment VALUES (694, '2015-09-12 00:00:00+01', 'nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac', 28, 243);
INSERT INTO comment VALUES (695, '2016-05-26 00:00:00+01', 'rhoncus dui vel sem sed sagittis nam congue risus semper porta', 48, 173);
INSERT INTO comment VALUES (696, '2016-10-10 00:00:00+01', 'vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget', 44, 217);
INSERT INTO comment VALUES (697, '2015-12-30 00:00:00+00', 'vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam', 21, 28);
INSERT INTO comment VALUES (698, '2015-03-22 00:00:00+00', 'lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce', 79, 50);
INSERT INTO comment VALUES (699, '2015-10-09 00:00:00+01', 'vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis', 69, 89);
INSERT INTO comment VALUES (700, '2016-08-31 00:00:00+01', 'nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie', 80, 135);
INSERT INTO comment VALUES (701, '2018-02-26 00:00:00+00', 'ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in', 69, 83);
INSERT INTO comment VALUES (702, '2016-09-08 00:00:00+01', 'a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices', 43, 153);
INSERT INTO comment VALUES (703, '2015-12-18 00:00:00+00', 'sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper', 87, 22);
INSERT INTO comment VALUES (704, '2015-09-02 00:00:00+01', 'tempus sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis', 34, 112);
INSERT INTO comment VALUES (705, '2018-02-10 00:00:00+00', 'mi in porttitor pede justo eu massa donec dapibus duis', 62, 111);
INSERT INTO comment VALUES (706, '2017-01-13 00:00:00+00', 'at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis', 56, 50);
INSERT INTO comment VALUES (707, '2017-05-24 00:00:00+01', 'dui proin leo odio', 15, 269);
INSERT INTO comment VALUES (708, '2017-12-16 00:00:00+00', 'posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo', 77, 253);
INSERT INTO comment VALUES (709, '2017-04-17 00:00:00+01', 'tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor vel est', 48, 99);
INSERT INTO comment VALUES (710, '2017-11-06 00:00:00+00', 'eu orci mauris lacinia sapien quis libero nullam sit amet', 38, 119);
INSERT INTO comment VALUES (711, '2016-10-26 00:00:00+01', 'lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent', 92, 177);
INSERT INTO comment VALUES (712, '2017-01-12 00:00:00+00', 'non interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae', 78, 297);
INSERT INTO comment VALUES (713, '2017-12-14 00:00:00+00', 'nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum', 5, 7);
INSERT INTO comment VALUES (714, '2016-11-28 00:00:00+00', 'congue etiam justo etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate', 91, 253);
INSERT INTO comment VALUES (715, '2015-06-02 00:00:00+01', 'vel ipsum praesent blandit lacinia erat', 24, 69);
INSERT INTO comment VALUES (716, '2018-01-13 00:00:00+00', 'ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed', 46, 278);
INSERT INTO comment VALUES (756, '2017-02-11 00:00:00+00', 'vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque', 29, 117);
INSERT INTO comment VALUES (717, '2017-09-08 00:00:00+01', 'hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna', 84, 87);
INSERT INTO comment VALUES (718, '2016-06-23 00:00:00+01', 'est et tempus semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum', 79, 149);
INSERT INTO comment VALUES (719, '2016-03-06 00:00:00+00', 'posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac', 41, 130);
INSERT INTO comment VALUES (720, '2017-10-06 00:00:00+01', 'lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla', 31, 198);
INSERT INTO comment VALUES (721, '2015-08-01 00:00:00+01', 'congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi', 62, 231);
INSERT INTO comment VALUES (722, '2015-12-15 00:00:00+00', 'blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam', 66, 106);
INSERT INTO comment VALUES (723, '2016-09-25 00:00:00+01', 'at ipsum', 95, 298);
INSERT INTO comment VALUES (724, '2015-06-30 00:00:00+01', 'phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat', 58, 244);
INSERT INTO comment VALUES (725, '2017-06-29 00:00:00+01', 'maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam', 25, 286);
INSERT INTO comment VALUES (726, '2016-11-13 00:00:00+00', 'amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae', 81, 232);
INSERT INTO comment VALUES (727, '2015-09-18 00:00:00+01', 'morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi', 43, 146);
INSERT INTO comment VALUES (728, '2017-08-25 00:00:00+01', 'sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a', 71, 16);
INSERT INTO comment VALUES (729, '2017-04-17 00:00:00+01', 'ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a', 80, 276);
INSERT INTO comment VALUES (730, '2016-03-31 00:00:00+01', 'lectus aliquam sit amet diam in', 63, 218);
INSERT INTO comment VALUES (731, '2017-05-16 00:00:00+01', 'faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis', 12, 22);
INSERT INTO comment VALUES (732, '2016-01-12 00:00:00+00', 'augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in hac habitasse platea dictumst etiam', 33, 107);
INSERT INTO comment VALUES (733, '2017-06-09 00:00:00+01', 'commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit', 13, 204);
INSERT INTO comment VALUES (734, '2017-05-22 00:00:00+01', 'nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse', 80, 257);
INSERT INTO comment VALUES (735, '2015-10-06 00:00:00+01', 'lobortis est phasellus sit amet erat nulla tempus', 59, 259);
INSERT INTO comment VALUES (736, '2018-01-12 00:00:00+00', 'nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien', 54, 26);
INSERT INTO comment VALUES (737, '2017-04-16 00:00:00+01', 'mattis pulvinar nulla pede ullamcorper', 36, 140);
INSERT INTO comment VALUES (738, '2017-01-11 00:00:00+00', 'nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac', 54, 142);
INSERT INTO comment VALUES (739, '2015-07-03 00:00:00+01', 'sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend', 12, 288);
INSERT INTO comment VALUES (740, '2016-09-14 00:00:00+01', 'laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla', 71, 6);
INSERT INTO comment VALUES (741, '2015-10-20 00:00:00+01', 'est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at', 34, 247);
INSERT INTO comment VALUES (742, '2016-10-09 00:00:00+01', 'non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat', 11, 277);
INSERT INTO comment VALUES (743, '2017-07-03 00:00:00+01', 'curae donec pharetra magna vestibulum aliquet', 87, 41);
INSERT INTO comment VALUES (744, '2016-09-08 00:00:00+01', 'sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci', 57, 290);
INSERT INTO comment VALUES (745, '2015-07-10 00:00:00+01', 'vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi', 25, 118);
INSERT INTO comment VALUES (746, '2015-11-10 00:00:00+00', 'id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim', 32, 83);
INSERT INTO comment VALUES (747, '2016-11-09 00:00:00+00', 'ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis', 4, 79);
INSERT INTO comment VALUES (748, '2017-05-24 00:00:00+01', 'at nibh in hac', 98, 5);
INSERT INTO comment VALUES (749, '2017-11-04 00:00:00+00', 'molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien', 94, 233);
INSERT INTO comment VALUES (750, '2016-05-22 00:00:00+01', 'porttitor id consequat in consequat ut nulla sed', 73, 167);
INSERT INTO comment VALUES (751, '2016-07-27 00:00:00+01', 'libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio condimentum id luctus nec molestie sed justo', 30, 29);
INSERT INTO comment VALUES (752, '2017-10-24 00:00:00+01', 'feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla', 12, 59);
INSERT INTO comment VALUES (753, '2016-02-08 00:00:00+00', 'erat', 22, 214);
INSERT INTO comment VALUES (754, '2015-10-14 00:00:00+01', 'mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing', 36, 124);
INSERT INTO comment VALUES (757, '2015-12-18 00:00:00+00', 'luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum', 92, 233);
INSERT INTO comment VALUES (758, '2017-10-19 00:00:00+01', 'proin risus praesent lectus vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus', 32, 250);
INSERT INTO comment VALUES (759, '2016-05-28 00:00:00+01', 'tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet sem fusce consequat nulla nisl', 22, 148);
INSERT INTO comment VALUES (760, '2015-07-06 00:00:00+01', 'libero non mattis pulvinar nulla', 95, 122);
INSERT INTO comment VALUES (761, '2016-07-24 00:00:00+01', 'pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis', 49, 204);
INSERT INTO comment VALUES (762, '2015-09-28 00:00:00+01', 'nam tristique tortor eu', 61, 107);
INSERT INTO comment VALUES (763, '2017-08-23 00:00:00+01', 'natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et', 60, 235);
INSERT INTO comment VALUES (764, '2016-01-07 00:00:00+00', 'donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit', 80, 85);
INSERT INTO comment VALUES (765, '2016-05-12 00:00:00+01', 'ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci', 94, 45);
INSERT INTO comment VALUES (766, '2017-03-23 00:00:00+00', 'tempus sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue', 96, 289);
INSERT INTO comment VALUES (767, '2015-10-12 00:00:00+01', 'dapibus dolor vel est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam', 9, 16);
INSERT INTO comment VALUES (768, '2016-11-05 00:00:00+00', 'non interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet', 40, 98);
INSERT INTO comment VALUES (769, '2018-01-06 00:00:00+00', 'sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in', 34, 260);
INSERT INTO comment VALUES (770, '2015-10-25 00:00:00+01', 'massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque', 72, 94);
INSERT INTO comment VALUES (771, '2015-07-12 00:00:00+01', 'ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam', 97, 211);
INSERT INTO comment VALUES (772, '2015-04-11 00:00:00+01', 'proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla', 81, 287);
INSERT INTO comment VALUES (773, '2016-08-01 00:00:00+01', 'condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien', 41, 178);
INSERT INTO comment VALUES (774, '2018-01-24 00:00:00+00', 'lacus curabitur at ipsum', 7, 88);
INSERT INTO comment VALUES (775, '2015-12-06 00:00:00+00', 'donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet', 57, 143);
INSERT INTO comment VALUES (776, '2015-08-25 00:00:00+01', 'risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur', 99, 146);
INSERT INTO comment VALUES (777, '2016-04-11 00:00:00+01', 'nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet', 29, 45);
INSERT INTO comment VALUES (778, '2017-09-03 00:00:00+01', 'primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor vel est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac', 37, 216);
INSERT INTO comment VALUES (779, '2016-12-30 00:00:00+00', 'donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac', 100, 8);
INSERT INTO comment VALUES (780, '2016-03-16 00:00:00+00', 'blandit non', 7, 252);
INSERT INTO comment VALUES (781, '2017-03-10 00:00:00+00', 'mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci', 82, 297);
INSERT INTO comment VALUES (782, '2015-06-18 00:00:00+01', 'morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem', 97, 121);
INSERT INTO comment VALUES (783, '2016-12-17 00:00:00+00', 'luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst', 52, 68);
INSERT INTO comment VALUES (784, '2017-11-05 00:00:00+00', 'vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero', 52, 59);
INSERT INTO comment VALUES (785, '2015-12-26 00:00:00+00', 'rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor', 75, 60);
INSERT INTO comment VALUES (786, '2017-01-25 00:00:00+00', 'natoque penatibus et magnis dis parturient montes nascetur ridiculus mus', 30, 155);
INSERT INTO comment VALUES (787, '2016-08-28 00:00:00+01', 'aliquam sit amet diam', 49, 14);
INSERT INTO comment VALUES (788, '2017-11-21 00:00:00+00', 'potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa', 13, 292);
INSERT INTO comment VALUES (789, '2015-04-13 00:00:00+01', 'consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam', 46, 232);
INSERT INTO comment VALUES (790, '2015-04-05 00:00:00+01', 'at turpis a pede posuere nonummy', 100, 218);
INSERT INTO comment VALUES (791, '2016-10-29 00:00:00+01', 'pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas', 12, 215);
INSERT INTO comment VALUES (792, '2016-03-04 00:00:00+00', 'maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus', 40, 181);
INSERT INTO comment VALUES (793, '2016-01-08 00:00:00+00', 'sed tristique in tempus sit amet', 32, 202);
INSERT INTO comment VALUES (794, '2016-01-26 00:00:00+00', 'quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec', 31, 91);
INSERT INTO comment VALUES (795, '2015-07-04 00:00:00+01', 'rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo', 19, 256);
INSERT INTO comment VALUES (796, '2015-05-10 00:00:00+01', 'turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede', 25, 171);
INSERT INTO comment VALUES (797, '2015-05-11 00:00:00+01', 'in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate', 100, 187);
INSERT INTO comment VALUES (798, '2015-08-17 00:00:00+01', 'quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis', 42, 77);
INSERT INTO comment VALUES (799, '2016-09-16 00:00:00+01', 'vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien', 63, 92);
INSERT INTO comment VALUES (800, '2015-11-06 00:00:00+00', 'pharetra', 67, 269);
INSERT INTO comment VALUES (801, '2018-01-25 00:00:00+00', 'ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac', 80, 296);
INSERT INTO comment VALUES (802, '2018-02-17 00:00:00+00', 'condimentum id luctus nec molestie', 57, 33);
INSERT INTO comment VALUES (803, '2016-08-13 00:00:00+01', 'ut blandit non interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut', 87, 179);
INSERT INTO comment VALUES (804, '2017-02-11 00:00:00+00', 'velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut', 76, 295);
INSERT INTO comment VALUES (805, '2016-09-27 00:00:00+01', 'elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget', 55, 187);
INSERT INTO comment VALUES (806, '2017-10-04 00:00:00+01', 'in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede', 30, 296);
INSERT INTO comment VALUES (807, '2015-10-03 00:00:00+01', 'mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum', 7, 5);
INSERT INTO comment VALUES (808, '2015-04-11 00:00:00+01', 'vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis', 16, 53);
INSERT INTO comment VALUES (809, '2016-09-20 00:00:00+01', 'aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero', 85, 211);
INSERT INTO comment VALUES (810, '2017-10-20 00:00:00+01', 'primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor vel est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare', 83, 155);
INSERT INTO comment VALUES (811, '2015-11-18 00:00:00+00', 'felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam', 74, 297);
INSERT INTO comment VALUES (812, '2017-03-16 00:00:00+00', 'nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum', 82, 176);
INSERT INTO comment VALUES (813, '2017-02-16 00:00:00+00', 'donec vitae nisi nam', 21, 115);
INSERT INTO comment VALUES (814, '2016-08-17 00:00:00+01', 'mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient', 75, 166);
INSERT INTO comment VALUES (815, '2017-09-13 00:00:00+01', 'aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis', 84, 102);
INSERT INTO comment VALUES (816, '2016-09-15 00:00:00+01', 'suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed', 37, 154);
INSERT INTO comment VALUES (817, '2016-02-12 00:00:00+00', 'suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna', 7, 41);
INSERT INTO comment VALUES (818, '2015-12-14 00:00:00+00', 'turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend', 72, 213);
INSERT INTO comment VALUES (819, '2017-12-06 00:00:00+00', 'elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy', 82, 236);
INSERT INTO comment VALUES (820, '2015-04-08 00:00:00+01', 'diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus', 73, 231);
INSERT INTO comment VALUES (821, '2017-08-09 00:00:00+01', 'pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat', 50, 298);
INSERT INTO comment VALUES (822, '2018-02-08 00:00:00+00', 'justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat', 89, 114);
INSERT INTO comment VALUES (823, '2016-02-27 00:00:00+00', 'eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at', 25, 255);
INSERT INTO comment VALUES (824, '2016-12-27 00:00:00+00', 'pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet sem fusce consequat nulla nisl nunc nisl duis', 98, 83);
INSERT INTO comment VALUES (825, '2015-04-24 00:00:00+01', 'ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec', 77, 109);
INSERT INTO comment VALUES (826, '2017-10-11 00:00:00+01', 'vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla', 51, 49);
INSERT INTO comment VALUES (902, '2017-11-28 00:00:00+00', 'nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat', 49, 111);
INSERT INTO comment VALUES (827, '2018-01-07 00:00:00+00', 'et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat', 67, 32);
INSERT INTO comment VALUES (828, '2016-04-22 00:00:00+01', 'vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue', 63, 277);
INSERT INTO comment VALUES (829, '2015-10-04 00:00:00+01', 'mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis', 64, 205);
INSERT INTO comment VALUES (830, '2016-04-19 00:00:00+01', 'sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris', 5, 51);
INSERT INTO comment VALUES (831, '2015-05-11 00:00:00+01', 'pellentesque at nulla suspendisse potenti cras in purus', 99, 74);
INSERT INTO comment VALUES (832, '2016-10-23 00:00:00+01', 'mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem', 73, 15);
INSERT INTO comment VALUES (833, '2016-02-28 00:00:00+00', 'nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat', 7, 17);
INSERT INTO comment VALUES (834, '2015-07-23 00:00:00+01', 'sed tristique in tempus sit amet sem', 78, 226);
INSERT INTO comment VALUES (835, '2016-08-24 00:00:00+01', 'justo eu massa donec dapibus duis at velit eu est congue elementum in hac', 62, 276);
INSERT INTO comment VALUES (836, '2017-12-15 00:00:00+00', 'convallis nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien', 39, 76);
INSERT INTO comment VALUES (837, '2015-12-15 00:00:00+00', 'potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis', 81, 10);
INSERT INTO comment VALUES (838, '2016-08-21 00:00:00+01', 'fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta', 25, 140);
INSERT INTO comment VALUES (839, '2017-02-10 00:00:00+00', 'leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor', 28, 262);
INSERT INTO comment VALUES (840, '2016-01-14 00:00:00+00', 'magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum', 46, 1);
INSERT INTO comment VALUES (841, '2017-01-27 00:00:00+00', 'ornare imperdiet sapien urna pretium nisl ut volutpat sapien', 72, 32);
INSERT INTO comment VALUES (842, '2017-11-22 00:00:00+00', 'ut blandit non interdum in ante vestibulum ante ipsum', 58, 115);
INSERT INTO comment VALUES (843, '2015-05-24 00:00:00+01', 'venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat', 2, 169);
INSERT INTO comment VALUES (844, '2018-01-21 00:00:00+00', 'natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo', 18, 6);
INSERT INTO comment VALUES (845, '2017-07-22 00:00:00+01', 'semper est quam pharetra magna ac consequat metus sapien ut', 99, 86);
INSERT INTO comment VALUES (846, '2016-01-23 00:00:00+00', 'nullam orci pede venenatis non sodales sed tincidunt', 73, 268);
INSERT INTO comment VALUES (847, '2017-07-03 00:00:00+01', 'nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus', 90, 117);
INSERT INTO comment VALUES (848, '2017-09-11 00:00:00+01', 'rhoncus dui vel sem sed sagittis nam', 92, 69);
INSERT INTO comment VALUES (849, '2017-04-08 00:00:00+01', 'eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum', 35, 286);
INSERT INTO comment VALUES (850, '2015-06-27 00:00:00+01', 'dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus', 33, 34);
INSERT INTO comment VALUES (851, '2017-10-12 00:00:00+01', 'amet sapien dignissim vestibulum', 33, 20);
INSERT INTO comment VALUES (852, '2016-05-30 00:00:00+01', 'magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum', 8, 224);
INSERT INTO comment VALUES (853, '2017-01-28 00:00:00+00', 'mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean', 66, 38);
INSERT INTO comment VALUES (854, '2016-10-14 00:00:00+01', 'feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut', 60, 138);
INSERT INTO comment VALUES (855, '2017-12-15 00:00:00+00', 'sapien arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut', 91, 250);
INSERT INTO comment VALUES (856, '2017-02-15 00:00:00+00', 'in lectus pellentesque', 48, 186);
INSERT INTO comment VALUES (857, '2017-02-12 00:00:00+00', 'sed justo pellentesque viverra', 65, 244);
INSERT INTO comment VALUES (858, '2016-12-16 00:00:00+00', 'ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor vel est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium', 92, 176);
INSERT INTO comment VALUES (859, '2015-04-03 00:00:00+01', 'consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel', 29, 268);
INSERT INTO comment VALUES (860, '2017-02-17 00:00:00+00', 'morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend', 57, 103);
INSERT INTO comment VALUES (861, '2017-11-26 00:00:00+00', 'vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus', 53, 269);
INSERT INTO comment VALUES (862, '2017-06-19 00:00:00+01', 'nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris', 32, 229);
INSERT INTO comment VALUES (863, '2017-12-10 00:00:00+00', 'mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu', 76, 11);
INSERT INTO comment VALUES (864, '2016-10-13 00:00:00+01', 'curae nulla dapibus dolor vel est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis', 95, 175);
INSERT INTO comment VALUES (903, '2016-09-06 00:00:00+01', 'ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio', 5, 90);
INSERT INTO comment VALUES (865, '2017-09-16 00:00:00+01', 'ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum', 8, 204);
INSERT INTO comment VALUES (866, '2015-05-05 00:00:00+01', 'vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis', 97, 141);
INSERT INTO comment VALUES (867, '2015-08-24 00:00:00+01', 'nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in', 35, 259);
INSERT INTO comment VALUES (868, '2016-11-07 00:00:00+00', 'curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis', 37, 129);
INSERT INTO comment VALUES (869, '2017-06-26 00:00:00+01', 'semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla', 73, 71);
INSERT INTO comment VALUES (870, '2016-12-17 00:00:00+00', 'felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis', 50, 223);
INSERT INTO comment VALUES (871, '2018-01-30 00:00:00+00', 'dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu', 65, 99);
INSERT INTO comment VALUES (872, '2016-08-23 00:00:00+01', 'vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue', 62, 27);
INSERT INTO comment VALUES (873, '2017-04-07 00:00:00+01', 'duis ac', 54, 9);
INSERT INTO comment VALUES (874, '2016-03-29 00:00:00+01', 'suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec', 59, 116);
INSERT INTO comment VALUES (875, '2016-11-19 00:00:00+00', 'lobortis vel dapibus at diam nam tristique', 24, 260);
INSERT INTO comment VALUES (876, '2016-11-19 00:00:00+00', 'magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed', 61, 92);
INSERT INTO comment VALUES (877, '2016-09-29 00:00:00+01', 'leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus', 20, 185);
INSERT INTO comment VALUES (878, '2016-08-25 00:00:00+01', 'a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel dapibus at diam nam tristique tortor', 13, 299);
INSERT INTO comment VALUES (879, '2017-12-27 00:00:00+00', 'sit amet sapien dignissim', 94, 60);
INSERT INTO comment VALUES (880, '2016-05-29 00:00:00+01', 'odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien', 11, 212);
INSERT INTO comment VALUES (881, '2016-10-16 00:00:00+01', 'suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac', 93, 160);
INSERT INTO comment VALUES (882, '2015-08-31 00:00:00+01', 'convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien', 5, 213);
INSERT INTO comment VALUES (883, '2017-10-03 00:00:00+01', 'nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam', 51, 166);
INSERT INTO comment VALUES (884, '2017-06-23 00:00:00+01', 'odio cras mi pede', 96, 124);
INSERT INTO comment VALUES (885, '2015-03-28 00:00:00+00', 'etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl', 31, 39);
INSERT INTO comment VALUES (886, '2018-03-05 00:00:00+00', 'nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel dapibus at diam', 11, 264);
INSERT INTO comment VALUES (887, '2015-09-30 00:00:00+01', 'molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu', 6, 274);
INSERT INTO comment VALUES (888, '2016-03-21 00:00:00+00', 'tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc', 32, 69);
INSERT INTO comment VALUES (889, '2016-03-05 00:00:00+00', 'in leo maecenas pulvinar lobortis est phasellus', 93, 129);
INSERT INTO comment VALUES (890, '2017-03-28 00:00:00+01', 'id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus', 35, 233);
INSERT INTO comment VALUES (891, '2017-10-19 00:00:00+01', 'id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a', 68, 23);
INSERT INTO comment VALUES (892, '2017-10-21 00:00:00+01', 'metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar', 50, 38);
INSERT INTO comment VALUES (893, '2017-02-01 00:00:00+00', 'pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque', 32, 100);
INSERT INTO comment VALUES (894, '2015-03-20 00:00:00+00', 'eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis', 79, 253);
INSERT INTO comment VALUES (895, '2015-11-03 00:00:00+00', 'posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus', 17, 174);
INSERT INTO comment VALUES (896, '2016-05-14 00:00:00+01', 'et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus', 63, 82);
INSERT INTO comment VALUES (897, '2015-06-25 00:00:00+01', 'vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet', 21, 293);
INSERT INTO comment VALUES (898, '2017-10-17 00:00:00+01', 'quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo', 43, 45);
INSERT INTO comment VALUES (899, '2015-04-10 00:00:00+01', 'turpis elementum', 90, 37);
INSERT INTO comment VALUES (900, '2015-03-21 00:00:00+00', 'at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id', 50, 256);
INSERT INTO comment VALUES (901, '2016-10-20 00:00:00+01', 'diam erat fermentum justo nec condimentum neque sapien', 95, 223);
INSERT INTO comment VALUES (904, '2015-07-10 00:00:00+01', 'in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in', 54, 283);
INSERT INTO comment VALUES (905, '2016-06-12 00:00:00+01', 'purus eu magna', 22, 201);
INSERT INTO comment VALUES (906, '2018-01-05 00:00:00+00', 'tristique fusce congue diam id ornare imperdiet sapien urna', 98, 270);
INSERT INTO comment VALUES (907, '2016-10-31 00:00:00+00', 'potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur', 94, 102);
INSERT INTO comment VALUES (908, '2017-06-15 00:00:00+01', 'leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam', 52, 212);
INSERT INTO comment VALUES (909, '2017-11-29 00:00:00+00', 'id consequat in consequat ut nulla sed accumsan felis ut at', 12, 221);
INSERT INTO comment VALUES (910, '2015-08-18 00:00:00+01', 'donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac', 34, 12);
INSERT INTO comment VALUES (911, '2015-10-15 00:00:00+01', 'convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci', 33, 64);
INSERT INTO comment VALUES (912, '2015-05-31 00:00:00+01', 'sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam', 62, 41);
INSERT INTO comment VALUES (913, '2017-07-02 00:00:00+01', 'primis in faucibus orci luctus et ultrices', 79, 4);
INSERT INTO comment VALUES (914, '2017-01-26 00:00:00+00', 'ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet', 26, 181);
INSERT INTO comment VALUES (915, '2018-01-03 00:00:00+00', 'accumsan', 12, 145);
INSERT INTO comment VALUES (916, '2017-07-27 00:00:00+01', 'lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut', 16, 155);
INSERT INTO comment VALUES (917, '2016-11-19 00:00:00+00', 'volutpat convallis morbi odio odio elementum eu interdum eu tincidunt', 16, 158);
INSERT INTO comment VALUES (918, '2016-07-01 00:00:00+01', 'nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non', 6, 198);
INSERT INTO comment VALUES (919, '2015-11-04 00:00:00+00', 'quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec', 74, 246);
INSERT INTO comment VALUES (920, '2015-08-30 00:00:00+01', 'diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus', 94, 84);
INSERT INTO comment VALUES (921, '2015-10-12 00:00:00+01', 'ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet', 86, 230);
INSERT INTO comment VALUES (922, '2018-02-11 00:00:00+00', 'phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec', 62, 70);
INSERT INTO comment VALUES (923, '2017-05-25 00:00:00+01', 'lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut', 85, 127);
INSERT INTO comment VALUES (924, '2015-12-05 00:00:00+00', 'ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit', 18, 94);
INSERT INTO comment VALUES (925, '2017-07-30 00:00:00+01', 'diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris', 60, 126);
INSERT INTO comment VALUES (926, '2015-08-01 00:00:00+01', 'pede', 68, 125);
INSERT INTO comment VALUES (927, '2015-10-19 00:00:00+01', 'eu sapien cursus vestibulum proin eu', 74, 221);
INSERT INTO comment VALUES (928, '2015-12-05 00:00:00+00', 'integer ac leo pellentesque ultrices mattis odio donec vitae nisi', 60, 32);
INSERT INTO comment VALUES (929, '2017-06-08 00:00:00+01', 'nunc viverra', 76, 89);
INSERT INTO comment VALUES (930, '2017-06-30 00:00:00+01', 'at velit eu', 18, 146);
INSERT INTO comment VALUES (931, '2017-10-20 00:00:00+01', 'justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum', 69, 119);
INSERT INTO comment VALUES (932, '2017-06-27 00:00:00+01', 'quisque porta volutpat erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer', 91, 296);
INSERT INTO comment VALUES (933, '2016-06-03 00:00:00+01', 'pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non', 65, 96);
INSERT INTO comment VALUES (934, '2016-05-28 00:00:00+01', 'tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh', 60, 88);
INSERT INTO comment VALUES (935, '2017-06-24 00:00:00+01', 'arcu libero rutrum ac lobortis vel dapibus', 38, 142);
INSERT INTO comment VALUES (936, '2017-06-15 00:00:00+01', 'vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet', 47, 81);
INSERT INTO comment VALUES (937, '2016-09-02 00:00:00+01', 'est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus', 46, 179);
INSERT INTO comment VALUES (938, '2017-07-11 00:00:00+01', 'pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero', 46, 167);
INSERT INTO comment VALUES (939, '2016-03-25 00:00:00+00', 'integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in', 4, 6);
INSERT INTO comment VALUES (940, '2016-01-19 00:00:00+00', 'sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor vel est donec odio justo sollicitudin ut', 50, 26);
INSERT INTO comment VALUES (941, '2016-05-12 00:00:00+01', 'at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula', 21, 64);
INSERT INTO comment VALUES (942, '2017-07-25 00:00:00+01', 'dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit', 62, 136);
INSERT INTO comment VALUES (943, '2016-09-01 00:00:00+01', 'in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus', 23, 174);
INSERT INTO comment VALUES (944, '2018-02-12 00:00:00+00', 'nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo', 71, 58);
INSERT INTO comment VALUES (945, '2015-04-07 00:00:00+01', 'ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor', 90, 191);
INSERT INTO comment VALUES (946, '2015-09-12 00:00:00+01', 'adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus', 13, 184);
INSERT INTO comment VALUES (947, '2016-04-23 00:00:00+01', 'mus etiam vel augue', 62, 151);
INSERT INTO comment VALUES (948, '2018-01-19 00:00:00+00', 'ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula', 70, 101);
INSERT INTO comment VALUES (949, '2015-06-18 00:00:00+01', 'vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem', 62, 201);
INSERT INTO comment VALUES (950, '2017-05-18 00:00:00+01', 'ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus', 69, 222);
INSERT INTO comment VALUES (951, '2016-02-21 00:00:00+00', 'eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor', 61, 174);
INSERT INTO comment VALUES (952, '2015-03-24 00:00:00+00', 'nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et', 80, 13);
INSERT INTO comment VALUES (953, '2017-07-29 00:00:00+01', 'tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices', 52, 206);
INSERT INTO comment VALUES (954, '2017-04-20 00:00:00+01', 'montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit', 9, 119);
INSERT INTO comment VALUES (955, '2016-12-22 00:00:00+00', 'luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien', 90, 196);
INSERT INTO comment VALUES (956, '2015-10-31 00:00:00+00', 'congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor', 57, 97);
INSERT INTO comment VALUES (957, '2018-01-05 00:00:00+00', 'vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis', 2, 55);
INSERT INTO comment VALUES (958, '2018-03-13 00:00:00+00', 'sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor vel est donec odio justo sollicitudin ut suscipit a feugiat', 9, 35);
INSERT INTO comment VALUES (959, '2018-02-02 00:00:00+00', 'justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam', 53, 275);
INSERT INTO comment VALUES (960, '2017-10-31 00:00:00+00', 'tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus', 58, 164);
INSERT INTO comment VALUES (961, '2017-07-06 00:00:00+01', 'ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia', 63, 234);
INSERT INTO comment VALUES (962, '2015-05-15 00:00:00+01', 'ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel dapibus at diam nam tristique tortor', 1, 123);
INSERT INTO comment VALUES (963, '2015-04-06 00:00:00+01', 'tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet sem', 77, 4);
INSERT INTO comment VALUES (964, '2015-12-16 00:00:00+00', 'in', 55, 292);
INSERT INTO comment VALUES (965, '2017-11-03 00:00:00+00', 'nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit', 23, 277);
INSERT INTO comment VALUES (966, '2015-09-27 00:00:00+01', 'ultrices aliquet maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac', 68, 283);
INSERT INTO comment VALUES (967, '2016-01-21 00:00:00+00', 'sed tristique in tempus sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi', 81, 144);
INSERT INTO comment VALUES (968, '2016-03-27 00:00:00+00', 'tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy', 100, 12);
INSERT INTO comment VALUES (969, '2017-08-31 00:00:00+01', 'hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non', 84, 125);
INSERT INTO comment VALUES (970, '2015-11-02 00:00:00+00', 'rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae', 86, 226);
INSERT INTO comment VALUES (971, '2016-10-24 00:00:00+01', 'sodales sed tincidunt eu felis fusce posuere', 24, 201);
INSERT INTO comment VALUES (972, '2015-05-28 00:00:00+01', 'mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit', 57, 13);
INSERT INTO comment VALUES (973, '2016-12-01 00:00:00+00', 'hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum', 74, 183);
INSERT INTO comment VALUES (974, '2016-02-22 00:00:00+00', 'vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis', 39, 63);
INSERT INTO comment VALUES (975, '2017-11-23 00:00:00+00', 'orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices', 65, 299);
INSERT INTO comment VALUES (976, '2017-01-24 00:00:00+00', 'amet eros suspendisse accumsan tortor quis turpis sed ante', 47, 262);
INSERT INTO comment VALUES (977, '2016-07-07 00:00:00+01', 'nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet', 62, 4);
INSERT INTO comment VALUES (978, '2015-05-16 00:00:00+01', 'vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus', 5, 178);
INSERT INTO comment VALUES (979, '2017-06-17 00:00:00+01', 'felis ut at dolor quis', 22, 91);
INSERT INTO comment VALUES (980, '2016-12-04 00:00:00+00', 'ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in hac', 44, 165);
INSERT INTO comment VALUES (981, '2017-01-25 00:00:00+00', 'id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia', 62, 149);
INSERT INTO comment VALUES (982, '2017-04-15 00:00:00+01', 'sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend', 34, 285);
INSERT INTO comment VALUES (983, '2016-06-29 00:00:00+01', 'quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere', 11, 277);
INSERT INTO comment VALUES (984, '2015-05-13 00:00:00+01', 'sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum', 8, 286);
INSERT INTO comment VALUES (985, '2016-06-27 00:00:00+01', 'vestibulum velit id pretium iaculis diam', 87, 97);
INSERT INTO comment VALUES (986, '2015-12-01 00:00:00+00', 'aliquet at feugiat non pretium', 22, 240);
INSERT INTO comment VALUES (987, '2015-10-26 00:00:00+00', 'sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa', 36, 84);
INSERT INTO comment VALUES (988, '2017-07-05 00:00:00+01', 'justo eu massa donec dapibus duis at velit eu est congue elementum', 51, 148);
INSERT INTO comment VALUES (989, '2015-10-07 00:00:00+01', 'aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque', 44, 2);
INSERT INTO comment VALUES (990, '2016-08-23 00:00:00+01', 'vulputate nonummy maecenas tincidunt lacus at velit vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien', 18, 122);
INSERT INTO comment VALUES (991, '2016-02-15 00:00:00+00', 'justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula', 1, 258);
INSERT INTO comment VALUES (992, '2016-06-06 00:00:00+01', 'hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus', 34, 170);
INSERT INTO comment VALUES (993, '2015-09-26 00:00:00+01', 'enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae', 38, 55);
INSERT INTO comment VALUES (994, '2015-12-02 00:00:00+00', 'dui vel sem sed sagittis nam congue risus semper', 48, 14);
INSERT INTO comment VALUES (995, '2017-05-15 00:00:00+01', 'interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec', 61, 278);
INSERT INTO comment VALUES (996, '2017-08-29 00:00:00+01', 'ridiculus mus etiam vel augue', 65, 60);
INSERT INTO comment VALUES (997, '2016-01-23 00:00:00+00', 'diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi', 17, 74);
INSERT INTO comment VALUES (998, '2018-02-18 00:00:00+00', 'donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue', 97, 268);
INSERT INTO comment VALUES (999, '2017-07-18 00:00:00+01', 'sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat', 47, 137);
INSERT INTO comment VALUES (1000, '2015-09-02 00:00:00+01', 'in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in', 6, 14);


--
-- Name: comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1614
--

SELECT pg_catalog.setval('comment_id_seq', 16, true);


--
-- Data for Name: comment_like; Type: TABLE DATA; Schema: public; Owner: lbaw1614
--

INSERT INTO comment_like VALUES (701, 20);
INSERT INTO comment_like VALUES (554, 22);
INSERT INTO comment_like VALUES (477, 89);
INSERT INTO comment_like VALUES (728, 1);
INSERT INTO comment_like VALUES (423, 29);
INSERT INTO comment_like VALUES (135, 24);
INSERT INTO comment_like VALUES (913, 8);
INSERT INTO comment_like VALUES (921, 6);
INSERT INTO comment_like VALUES (875, 12);
INSERT INTO comment_like VALUES (468, 15);
INSERT INTO comment_like VALUES (548, 79);
INSERT INTO comment_like VALUES (369, 85);
INSERT INTO comment_like VALUES (758, 10);
INSERT INTO comment_like VALUES (954, 28);
INSERT INTO comment_like VALUES (683, 40);
INSERT INTO comment_like VALUES (215, 61);
INSERT INTO comment_like VALUES (337, 59);
INSERT INTO comment_like VALUES (561, 57);
INSERT INTO comment_like VALUES (930, 88);
INSERT INTO comment_like VALUES (772, 76);
INSERT INTO comment_like VALUES (907, 70);
INSERT INTO comment_like VALUES (20, 52);
INSERT INTO comment_like VALUES (932, 78);
INSERT INTO comment_like VALUES (404, 4);
INSERT INTO comment_like VALUES (510, 36);
INSERT INTO comment_like VALUES (866, 92);
INSERT INTO comment_like VALUES (340, 32);
INSERT INTO comment_like VALUES (950, 85);
INSERT INTO comment_like VALUES (494, 27);
INSERT INTO comment_like VALUES (941, 82);
INSERT INTO comment_like VALUES (492, 100);
INSERT INTO comment_like VALUES (963, 33);
INSERT INTO comment_like VALUES (761, 46);
INSERT INTO comment_like VALUES (644, 88);
INSERT INTO comment_like VALUES (975, 83);
INSERT INTO comment_like VALUES (707, 95);
INSERT INTO comment_like VALUES (808, 78);
INSERT INTO comment_like VALUES (775, 7);
INSERT INTO comment_like VALUES (38, 89);
INSERT INTO comment_like VALUES (654, 80);
INSERT INTO comment_like VALUES (662, 78);
INSERT INTO comment_like VALUES (987, 59);
INSERT INTO comment_like VALUES (939, 33);
INSERT INTO comment_like VALUES (670, 53);
INSERT INTO comment_like VALUES (913, 66);
INSERT INTO comment_like VALUES (717, 69);
INSERT INTO comment_like VALUES (280, 84);
INSERT INTO comment_like VALUES (143, 5);
INSERT INTO comment_like VALUES (578, 98);
INSERT INTO comment_like VALUES (718, 86);
INSERT INTO comment_like VALUES (317, 8);
INSERT INTO comment_like VALUES (420, 33);
INSERT INTO comment_like VALUES (184, 8);
INSERT INTO comment_like VALUES (824, 50);
INSERT INTO comment_like VALUES (493, 34);
INSERT INTO comment_like VALUES (232, 88);
INSERT INTO comment_like VALUES (770, 3);
INSERT INTO comment_like VALUES (716, 82);
INSERT INTO comment_like VALUES (494, 62);
INSERT INTO comment_like VALUES (498, 14);
INSERT INTO comment_like VALUES (856, 50);
INSERT INTO comment_like VALUES (962, 89);
INSERT INTO comment_like VALUES (455, 95);
INSERT INTO comment_like VALUES (99, 33);
INSERT INTO comment_like VALUES (133, 39);
INSERT INTO comment_like VALUES (60, 51);
INSERT INTO comment_like VALUES (227, 9);
INSERT INTO comment_like VALUES (54, 90);
INSERT INTO comment_like VALUES (82, 70);
INSERT INTO comment_like VALUES (248, 40);
INSERT INTO comment_like VALUES (962, 59);
INSERT INTO comment_like VALUES (972, 46);
INSERT INTO comment_like VALUES (79, 35);
INSERT INTO comment_like VALUES (890, 99);
INSERT INTO comment_like VALUES (190, 89);
INSERT INTO comment_like VALUES (528, 64);
INSERT INTO comment_like VALUES (63, 60);
INSERT INTO comment_like VALUES (175, 20);
INSERT INTO comment_like VALUES (914, 25);
INSERT INTO comment_like VALUES (969, 14);
INSERT INTO comment_like VALUES (484, 41);
INSERT INTO comment_like VALUES (802, 29);
INSERT INTO comment_like VALUES (939, 99);
INSERT INTO comment_like VALUES (559, 8);
INSERT INTO comment_like VALUES (633, 75);
INSERT INTO comment_like VALUES (99, 99);
INSERT INTO comment_like VALUES (306, 46);
INSERT INTO comment_like VALUES (847, 20);
INSERT INTO comment_like VALUES (784, 85);
INSERT INTO comment_like VALUES (28, 55);
INSERT INTO comment_like VALUES (917, 13);
INSERT INTO comment_like VALUES (446, 21);
INSERT INTO comment_like VALUES (145, 75);
INSERT INTO comment_like VALUES (944, 38);
INSERT INTO comment_like VALUES (791, 70);
INSERT INTO comment_like VALUES (347, 72);
INSERT INTO comment_like VALUES (976, 75);
INSERT INTO comment_like VALUES (397, 21);
INSERT INTO comment_like VALUES (937, 60);
INSERT INTO comment_like VALUES (216, 90);
INSERT INTO comment_like VALUES (713, 75);
INSERT INTO comment_like VALUES (819, 75);
INSERT INTO comment_like VALUES (45, 54);
INSERT INTO comment_like VALUES (905, 65);
INSERT INTO comment_like VALUES (449, 59);
INSERT INTO comment_like VALUES (349, 36);
INSERT INTO comment_like VALUES (773, 93);
INSERT INTO comment_like VALUES (843, 25);
INSERT INTO comment_like VALUES (885, 76);
INSERT INTO comment_like VALUES (50, 30);
INSERT INTO comment_like VALUES (764, 28);
INSERT INTO comment_like VALUES (965, 27);
INSERT INTO comment_like VALUES (83, 18);
INSERT INTO comment_like VALUES (664, 70);
INSERT INTO comment_like VALUES (35, 96);
INSERT INTO comment_like VALUES (227, 90);
INSERT INTO comment_like VALUES (292, 77);
INSERT INTO comment_like VALUES (439, 43);
INSERT INTO comment_like VALUES (447, 15);
INSERT INTO comment_like VALUES (965, 38);
INSERT INTO comment_like VALUES (528, 4);
INSERT INTO comment_like VALUES (990, 59);
INSERT INTO comment_like VALUES (311, 63);
INSERT INTO comment_like VALUES (164, 6);
INSERT INTO comment_like VALUES (348, 3);
INSERT INTO comment_like VALUES (960, 29);
INSERT INTO comment_like VALUES (543, 3);
INSERT INTO comment_like VALUES (250, 95);
INSERT INTO comment_like VALUES (107, 6);
INSERT INTO comment_like VALUES (209, 60);
INSERT INTO comment_like VALUES (939, 74);
INSERT INTO comment_like VALUES (212, 37);
INSERT INTO comment_like VALUES (528, 50);
INSERT INTO comment_like VALUES (909, 2);
INSERT INTO comment_like VALUES (251, 3);
INSERT INTO comment_like VALUES (805, 14);
INSERT INTO comment_like VALUES (219, 68);
INSERT INTO comment_like VALUES (541, 85);
INSERT INTO comment_like VALUES (533, 52);
INSERT INTO comment_like VALUES (988, 5);
INSERT INTO comment_like VALUES (215, 17);
INSERT INTO comment_like VALUES (617, 30);
INSERT INTO comment_like VALUES (652, 17);
INSERT INTO comment_like VALUES (963, 55);
INSERT INTO comment_like VALUES (414, 5);
INSERT INTO comment_like VALUES (902, 86);
INSERT INTO comment_like VALUES (527, 6);
INSERT INTO comment_like VALUES (433, 53);
INSERT INTO comment_like VALUES (3, 66);
INSERT INTO comment_like VALUES (834, 68);
INSERT INTO comment_like VALUES (686, 27);
INSERT INTO comment_like VALUES (249, 13);
INSERT INTO comment_like VALUES (815, 38);
INSERT INTO comment_like VALUES (856, 45);
INSERT INTO comment_like VALUES (896, 70);
INSERT INTO comment_like VALUES (82, 79);
INSERT INTO comment_like VALUES (923, 96);
INSERT INTO comment_like VALUES (83, 70);
INSERT INTO comment_like VALUES (390, 26);
INSERT INTO comment_like VALUES (571, 43);
INSERT INTO comment_like VALUES (399, 51);
INSERT INTO comment_like VALUES (650, 4);
INSERT INTO comment_like VALUES (845, 48);
INSERT INTO comment_like VALUES (284, 75);
INSERT INTO comment_like VALUES (750, 80);
INSERT INTO comment_like VALUES (883, 19);
INSERT INTO comment_like VALUES (863, 46);
INSERT INTO comment_like VALUES (560, 11);
INSERT INTO comment_like VALUES (277, 43);
INSERT INTO comment_like VALUES (160, 60);
INSERT INTO comment_like VALUES (134, 23);
INSERT INTO comment_like VALUES (809, 44);
INSERT INTO comment_like VALUES (237, 61);
INSERT INTO comment_like VALUES (441, 99);
INSERT INTO comment_like VALUES (694, 27);
INSERT INTO comment_like VALUES (50, 43);
INSERT INTO comment_like VALUES (334, 19);
INSERT INTO comment_like VALUES (781, 56);
INSERT INTO comment_like VALUES (679, 32);
INSERT INTO comment_like VALUES (506, 60);
INSERT INTO comment_like VALUES (612, 59);
INSERT INTO comment_like VALUES (464, 80);
INSERT INTO comment_like VALUES (655, 82);
INSERT INTO comment_like VALUES (61, 23);
INSERT INTO comment_like VALUES (1000, 47);
INSERT INTO comment_like VALUES (65, 67);
INSERT INTO comment_like VALUES (247, 92);
INSERT INTO comment_like VALUES (177, 17);
INSERT INTO comment_like VALUES (162, 28);
INSERT INTO comment_like VALUES (869, 8);
INSERT INTO comment_like VALUES (682, 45);
INSERT INTO comment_like VALUES (61, 20);
INSERT INTO comment_like VALUES (505, 69);
INSERT INTO comment_like VALUES (102, 25);
INSERT INTO comment_like VALUES (78, 14);
INSERT INTO comment_like VALUES (230, 51);
INSERT INTO comment_like VALUES (514, 97);
INSERT INTO comment_like VALUES (299, 28);
INSERT INTO comment_like VALUES (835, 20);
INSERT INTO comment_like VALUES (134, 95);
INSERT INTO comment_like VALUES (215, 63);
INSERT INTO comment_like VALUES (843, 90);
INSERT INTO comment_like VALUES (634, 4);
INSERT INTO comment_like VALUES (987, 21);
INSERT INTO comment_like VALUES (219, 57);
INSERT INTO comment_like VALUES (224, 67);
INSERT INTO comment_like VALUES (808, 88);
INSERT INTO comment_like VALUES (728, 53);
INSERT INTO comment_like VALUES (84, 6);
INSERT INTO comment_like VALUES (281, 97);
INSERT INTO comment_like VALUES (634, 27);
INSERT INTO comment_like VALUES (12, 75);
INSERT INTO comment_like VALUES (776, 65);
INSERT INTO comment_like VALUES (386, 35);
INSERT INTO comment_like VALUES (261, 11);
INSERT INTO comment_like VALUES (299, 71);
INSERT INTO comment_like VALUES (757, 12);
INSERT INTO comment_like VALUES (504, 3);
INSERT INTO comment_like VALUES (232, 54);
INSERT INTO comment_like VALUES (72, 2);
INSERT INTO comment_like VALUES (797, 61);
INSERT INTO comment_like VALUES (572, 30);
INSERT INTO comment_like VALUES (208, 36);
INSERT INTO comment_like VALUES (259, 62);
INSERT INTO comment_like VALUES (200, 55);
INSERT INTO comment_like VALUES (532, 47);
INSERT INTO comment_like VALUES (158, 65);
INSERT INTO comment_like VALUES (170, 17);
INSERT INTO comment_like VALUES (851, 98);
INSERT INTO comment_like VALUES (68, 17);
INSERT INTO comment_like VALUES (506, 64);
INSERT INTO comment_like VALUES (504, 39);
INSERT INTO comment_like VALUES (389, 8);
INSERT INTO comment_like VALUES (24, 70);
INSERT INTO comment_like VALUES (462, 11);
INSERT INTO comment_like VALUES (306, 37);
INSERT INTO comment_like VALUES (603, 17);
INSERT INTO comment_like VALUES (606, 76);
INSERT INTO comment_like VALUES (477, 20);
INSERT INTO comment_like VALUES (99, 37);
INSERT INTO comment_like VALUES (265, 24);
INSERT INTO comment_like VALUES (989, 98);
INSERT INTO comment_like VALUES (755, 78);
INSERT INTO comment_like VALUES (116, 87);
INSERT INTO comment_like VALUES (393, 29);
INSERT INTO comment_like VALUES (221, 33);
INSERT INTO comment_like VALUES (92, 38);
INSERT INTO comment_like VALUES (742, 23);
INSERT INTO comment_like VALUES (498, 72);
INSERT INTO comment_like VALUES (745, 5);
INSERT INTO comment_like VALUES (193, 14);
INSERT INTO comment_like VALUES (913, 67);
INSERT INTO comment_like VALUES (463, 26);
INSERT INTO comment_like VALUES (531, 97);
INSERT INTO comment_like VALUES (252, 21);
INSERT INTO comment_like VALUES (968, 83);
INSERT INTO comment_like VALUES (491, 2);
INSERT INTO comment_like VALUES (385, 71);
INSERT INTO comment_like VALUES (467, 53);
INSERT INTO comment_like VALUES (98, 33);
INSERT INTO comment_like VALUES (935, 61);
INSERT INTO comment_like VALUES (262, 69);
INSERT INTO comment_like VALUES (565, 34);
INSERT INTO comment_like VALUES (483, 80);
INSERT INTO comment_like VALUES (925, 25);
INSERT INTO comment_like VALUES (620, 30);
INSERT INTO comment_like VALUES (274, 43);
INSERT INTO comment_like VALUES (936, 45);
INSERT INTO comment_like VALUES (542, 32);
INSERT INTO comment_like VALUES (778, 54);
INSERT INTO comment_like VALUES (66, 31);
INSERT INTO comment_like VALUES (15, 54);
INSERT INTO comment_like VALUES (385, 57);
INSERT INTO comment_like VALUES (790, 46);
INSERT INTO comment_like VALUES (373, 91);
INSERT INTO comment_like VALUES (262, 47);
INSERT INTO comment_like VALUES (225, 19);
INSERT INTO comment_like VALUES (776, 84);
INSERT INTO comment_like VALUES (544, 22);
INSERT INTO comment_like VALUES (184, 92);
INSERT INTO comment_like VALUES (727, 92);
INSERT INTO comment_like VALUES (342, 78);
INSERT INTO comment_like VALUES (18, 52);
INSERT INTO comment_like VALUES (67, 86);
INSERT INTO comment_like VALUES (218, 86);
INSERT INTO comment_like VALUES (518, 97);
INSERT INTO comment_like VALUES (581, 29);
INSERT INTO comment_like VALUES (60, 7);
INSERT INTO comment_like VALUES (690, 15);
INSERT INTO comment_like VALUES (322, 13);
INSERT INTO comment_like VALUES (203, 25);
INSERT INTO comment_like VALUES (298, 24);
INSERT INTO comment_like VALUES (734, 31);
INSERT INTO comment_like VALUES (154, 49);
INSERT INTO comment_like VALUES (859, 50);
INSERT INTO comment_like VALUES (688, 87);
INSERT INTO comment_like VALUES (875, 20);
INSERT INTO comment_like VALUES (897, 92);
INSERT INTO comment_like VALUES (519, 64);
INSERT INTO comment_like VALUES (203, 36);
INSERT INTO comment_like VALUES (995, 53);
INSERT INTO comment_like VALUES (699, 28);
INSERT INTO comment_like VALUES (389, 52);
INSERT INTO comment_like VALUES (672, 1);
INSERT INTO comment_like VALUES (714, 89);
INSERT INTO comment_like VALUES (349, 49);
INSERT INTO comment_like VALUES (238, 30);
INSERT INTO comment_like VALUES (999, 74);
INSERT INTO comment_like VALUES (730, 2);
INSERT INTO comment_like VALUES (632, 60);
INSERT INTO comment_like VALUES (83, 7);
INSERT INTO comment_like VALUES (480, 79);
INSERT INTO comment_like VALUES (457, 53);
INSERT INTO comment_like VALUES (804, 8);
INSERT INTO comment_like VALUES (808, 21);
INSERT INTO comment_like VALUES (335, 12);
INSERT INTO comment_like VALUES (405, 32);
INSERT INTO comment_like VALUES (908, 5);
INSERT INTO comment_like VALUES (881, 64);
INSERT INTO comment_like VALUES (940, 56);
INSERT INTO comment_like VALUES (394, 24);
INSERT INTO comment_like VALUES (303, 58);
INSERT INTO comment_like VALUES (334, 15);
INSERT INTO comment_like VALUES (972, 15);
INSERT INTO comment_like VALUES (939, 98);
INSERT INTO comment_like VALUES (469, 54);
INSERT INTO comment_like VALUES (843, 19);
INSERT INTO comment_like VALUES (294, 71);
INSERT INTO comment_like VALUES (772, 21);
INSERT INTO comment_like VALUES (330, 32);
INSERT INTO comment_like VALUES (988, 89);
INSERT INTO comment_like VALUES (391, 59);
INSERT INTO comment_like VALUES (302, 93);
INSERT INTO comment_like VALUES (699, 39);
INSERT INTO comment_like VALUES (669, 56);
INSERT INTO comment_like VALUES (400, 97);
INSERT INTO comment_like VALUES (569, 37);
INSERT INTO comment_like VALUES (458, 36);
INSERT INTO comment_like VALUES (523, 23);
INSERT INTO comment_like VALUES (150, 84);
INSERT INTO comment_like VALUES (231, 27);
INSERT INTO comment_like VALUES (412, 34);
INSERT INTO comment_like VALUES (587, 40);
INSERT INTO comment_like VALUES (153, 48);
INSERT INTO comment_like VALUES (931, 99);
INSERT INTO comment_like VALUES (926, 49);
INSERT INTO comment_like VALUES (579, 65);
INSERT INTO comment_like VALUES (964, 27);
INSERT INTO comment_like VALUES (898, 92);
INSERT INTO comment_like VALUES (264, 7);
INSERT INTO comment_like VALUES (343, 83);
INSERT INTO comment_like VALUES (404, 37);
INSERT INTO comment_like VALUES (383, 82);
INSERT INTO comment_like VALUES (146, 49);
INSERT INTO comment_like VALUES (941, 88);
INSERT INTO comment_like VALUES (450, 24);
INSERT INTO comment_like VALUES (379, 26);
INSERT INTO comment_like VALUES (907, 95);
INSERT INTO comment_like VALUES (257, 63);
INSERT INTO comment_like VALUES (395, 6);
INSERT INTO comment_like VALUES (741, 79);
INSERT INTO comment_like VALUES (142, 85);
INSERT INTO comment_like VALUES (548, 64);
INSERT INTO comment_like VALUES (577, 1);
INSERT INTO comment_like VALUES (397, 62);
INSERT INTO comment_like VALUES (228, 81);
INSERT INTO comment_like VALUES (903, 89);
INSERT INTO comment_like VALUES (156, 100);
INSERT INTO comment_like VALUES (332, 7);
INSERT INTO comment_like VALUES (498, 95);
INSERT INTO comment_like VALUES (341, 54);
INSERT INTO comment_like VALUES (424, 63);
INSERT INTO comment_like VALUES (141, 8);
INSERT INTO comment_like VALUES (277, 41);
INSERT INTO comment_like VALUES (865, 41);
INSERT INTO comment_like VALUES (829, 58);
INSERT INTO comment_like VALUES (657, 26);
INSERT INTO comment_like VALUES (556, 93);
INSERT INTO comment_like VALUES (2, 13);
INSERT INTO comment_like VALUES (451, 62);
INSERT INTO comment_like VALUES (821, 79);
INSERT INTO comment_like VALUES (985, 56);
INSERT INTO comment_like VALUES (725, 49);
INSERT INTO comment_like VALUES (603, 46);
INSERT INTO comment_like VALUES (242, 14);
INSERT INTO comment_like VALUES (807, 29);
INSERT INTO comment_like VALUES (257, 68);
INSERT INTO comment_like VALUES (626, 70);
INSERT INTO comment_like VALUES (1000, 15);
INSERT INTO comment_like VALUES (186, 56);
INSERT INTO comment_like VALUES (362, 34);
INSERT INTO comment_like VALUES (634, 71);
INSERT INTO comment_like VALUES (608, 80);
INSERT INTO comment_like VALUES (73, 11);
INSERT INTO comment_like VALUES (172, 71);
INSERT INTO comment_like VALUES (254, 62);
INSERT INTO comment_like VALUES (623, 79);
INSERT INTO comment_like VALUES (561, 70);
INSERT INTO comment_like VALUES (840, 45);
INSERT INTO comment_like VALUES (20, 84);
INSERT INTO comment_like VALUES (145, 63);
INSERT INTO comment_like VALUES (779, 39);
INSERT INTO comment_like VALUES (620, 42);
INSERT INTO comment_like VALUES (208, 20);
INSERT INTO comment_like VALUES (689, 87);
INSERT INTO comment_like VALUES (424, 78);
INSERT INTO comment_like VALUES (126, 90);
INSERT INTO comment_like VALUES (685, 28);
INSERT INTO comment_like VALUES (157, 84);
INSERT INTO comment_like VALUES (819, 53);
INSERT INTO comment_like VALUES (788, 82);
INSERT INTO comment_like VALUES (402, 97);
INSERT INTO comment_like VALUES (166, 77);
INSERT INTO comment_like VALUES (145, 12);
INSERT INTO comment_like VALUES (991, 35);
INSERT INTO comment_like VALUES (115, 28);
INSERT INTO comment_like VALUES (411, 18);
INSERT INTO comment_like VALUES (426, 81);
INSERT INTO comment_like VALUES (84, 60);
INSERT INTO comment_like VALUES (240, 94);
INSERT INTO comment_like VALUES (801, 63);
INSERT INTO comment_like VALUES (34, 75);
INSERT INTO comment_like VALUES (391, 48);
INSERT INTO comment_like VALUES (286, 59);
INSERT INTO comment_like VALUES (744, 50);
INSERT INTO comment_like VALUES (197, 11);
INSERT INTO comment_like VALUES (515, 36);
INSERT INTO comment_like VALUES (961, 10);
INSERT INTO comment_like VALUES (378, 28);
INSERT INTO comment_like VALUES (458, 9);
INSERT INTO comment_like VALUES (910, 37);
INSERT INTO comment_like VALUES (354, 68);
INSERT INTO comment_like VALUES (164, 84);
INSERT INTO comment_like VALUES (942, 76);
INSERT INTO comment_like VALUES (339, 12);
INSERT INTO comment_like VALUES (477, 47);
INSERT INTO comment_like VALUES (269, 92);
INSERT INTO comment_like VALUES (742, 99);
INSERT INTO comment_like VALUES (662, 20);
INSERT INTO comment_like VALUES (572, 44);
INSERT INTO comment_like VALUES (318, 3);
INSERT INTO comment_like VALUES (793, 40);
INSERT INTO comment_like VALUES (279, 27);
INSERT INTO comment_like VALUES (33, 45);
INSERT INTO comment_like VALUES (403, 51);
INSERT INTO comment_like VALUES (544, 76);
INSERT INTO comment_like VALUES (98, 7);
INSERT INTO comment_like VALUES (248, 45);
INSERT INTO comment_like VALUES (641, 94);
INSERT INTO comment_like VALUES (151, 8);
INSERT INTO comment_like VALUES (294, 74);
INSERT INTO comment_like VALUES (625, 5);
INSERT INTO comment_like VALUES (417, 76);
INSERT INTO comment_like VALUES (339, 81);
INSERT INTO comment_like VALUES (974, 64);
INSERT INTO comment_like VALUES (45, 70);
INSERT INTO comment_like VALUES (249, 97);
INSERT INTO comment_like VALUES (951, 66);
INSERT INTO comment_like VALUES (595, 34);
INSERT INTO comment_like VALUES (179, 99);
INSERT INTO comment_like VALUES (946, 55);
INSERT INTO comment_like VALUES (570, 67);
INSERT INTO comment_like VALUES (335, 16);
INSERT INTO comment_like VALUES (546, 59);
INSERT INTO comment_like VALUES (196, 12);
INSERT INTO comment_like VALUES (640, 69);
INSERT INTO comment_like VALUES (990, 5);
INSERT INTO comment_like VALUES (227, 75);
INSERT INTO comment_like VALUES (529, 77);
INSERT INTO comment_like VALUES (663, 90);
INSERT INTO comment_like VALUES (600, 73);
INSERT INTO comment_like VALUES (206, 82);
INSERT INTO comment_like VALUES (669, 97);
INSERT INTO comment_like VALUES (960, 56);
INSERT INTO comment_like VALUES (637, 60);
INSERT INTO comment_like VALUES (479, 65);
INSERT INTO comment_like VALUES (948, 20);
INSERT INTO comment_like VALUES (20, 48);
INSERT INTO comment_like VALUES (1000, 25);
INSERT INTO comment_like VALUES (683, 100);
INSERT INTO comment_like VALUES (774, 62);
INSERT INTO comment_like VALUES (498, 80);
INSERT INTO comment_like VALUES (244, 2);
INSERT INTO comment_like VALUES (83, 15);
INSERT INTO comment_like VALUES (350, 33);
INSERT INTO comment_like VALUES (398, 51);
INSERT INTO comment_like VALUES (326, 39);
INSERT INTO comment_like VALUES (581, 75);
INSERT INTO comment_like VALUES (695, 10);
INSERT INTO comment_like VALUES (656, 65);
INSERT INTO comment_like VALUES (589, 89);
INSERT INTO comment_like VALUES (44, 20);
INSERT INTO comment_like VALUES (519, 94);
INSERT INTO comment_like VALUES (904, 68);
INSERT INTO comment_like VALUES (925, 3);
INSERT INTO comment_like VALUES (198, 94);
INSERT INTO comment_like VALUES (362, 58);
INSERT INTO comment_like VALUES (394, 37);
INSERT INTO comment_like VALUES (882, 34);
INSERT INTO comment_like VALUES (754, 36);
INSERT INTO comment_like VALUES (117, 36);
INSERT INTO comment_like VALUES (336, 22);
INSERT INTO comment_like VALUES (250, 56);
INSERT INTO comment_like VALUES (700, 76);
INSERT INTO comment_like VALUES (978, 44);
INSERT INTO comment_like VALUES (800, 43);
INSERT INTO comment_like VALUES (44, 86);
INSERT INTO comment_like VALUES (645, 28);
INSERT INTO comment_like VALUES (679, 57);
INSERT INTO comment_like VALUES (47, 41);
INSERT INTO comment_like VALUES (357, 27);
INSERT INTO comment_like VALUES (792, 30);
INSERT INTO comment_like VALUES (136, 2);
INSERT INTO comment_like VALUES (68, 80);
INSERT INTO comment_like VALUES (507, 73);
INSERT INTO comment_like VALUES (588, 82);
INSERT INTO comment_like VALUES (797, 68);
INSERT INTO comment_like VALUES (802, 25);
INSERT INTO comment_like VALUES (964, 82);
INSERT INTO comment_like VALUES (827, 82);
INSERT INTO comment_like VALUES (986, 35);
INSERT INTO comment_like VALUES (679, 17);
INSERT INTO comment_like VALUES (674, 79);
INSERT INTO comment_like VALUES (731, 52);
INSERT INTO comment_like VALUES (444, 47);
INSERT INTO comment_like VALUES (641, 46);
INSERT INTO comment_like VALUES (94, 38);
INSERT INTO comment_like VALUES (73, 10);
INSERT INTO comment_like VALUES (39, 51);
INSERT INTO comment_like VALUES (397, 51);
INSERT INTO comment_like VALUES (464, 51);
INSERT INTO comment_like VALUES (586, 95);
INSERT INTO comment_like VALUES (723, 85);
INSERT INTO comment_like VALUES (188, 22);
INSERT INTO comment_like VALUES (132, 16);
INSERT INTO comment_like VALUES (703, 73);
INSERT INTO comment_like VALUES (670, 59);
INSERT INTO comment_like VALUES (729, 49);
INSERT INTO comment_like VALUES (512, 53);
INSERT INTO comment_like VALUES (841, 62);
INSERT INTO comment_like VALUES (232, 41);
INSERT INTO comment_like VALUES (231, 96);
INSERT INTO comment_like VALUES (328, 49);
INSERT INTO comment_like VALUES (276, 18);
INSERT INTO comment_like VALUES (845, 92);
INSERT INTO comment_like VALUES (590, 78);
INSERT INTO comment_like VALUES (249, 68);
INSERT INTO comment_like VALUES (647, 95);
INSERT INTO comment_like VALUES (609, 89);
INSERT INTO comment_like VALUES (484, 39);
INSERT INTO comment_like VALUES (639, 59);
INSERT INTO comment_like VALUES (123, 74);
INSERT INTO comment_like VALUES (685, 30);
INSERT INTO comment_like VALUES (291, 25);
INSERT INTO comment_like VALUES (511, 20);
INSERT INTO comment_like VALUES (430, 49);
INSERT INTO comment_like VALUES (796, 59);
INSERT INTO comment_like VALUES (288, 79);
INSERT INTO comment_like VALUES (93, 79);
INSERT INTO comment_like VALUES (322, 42);
INSERT INTO comment_like VALUES (797, 7);
INSERT INTO comment_like VALUES (451, 15);
INSERT INTO comment_like VALUES (481, 23);
INSERT INTO comment_like VALUES (218, 76);
INSERT INTO comment_like VALUES (361, 2);
INSERT INTO comment_like VALUES (340, 98);
INSERT INTO comment_like VALUES (732, 44);
INSERT INTO comment_like VALUES (345, 44);
INSERT INTO comment_like VALUES (511, 23);
INSERT INTO comment_like VALUES (577, 99);
INSERT INTO comment_like VALUES (101, 72);
INSERT INTO comment_like VALUES (230, 55);
INSERT INTO comment_like VALUES (465, 13);
INSERT INTO comment_like VALUES (359, 48);
INSERT INTO comment_like VALUES (916, 30);
INSERT INTO comment_like VALUES (102, 15);
INSERT INTO comment_like VALUES (689, 8);
INSERT INTO comment_like VALUES (65, 7);
INSERT INTO comment_like VALUES (82, 89);
INSERT INTO comment_like VALUES (571, 10);
INSERT INTO comment_like VALUES (107, 78);
INSERT INTO comment_like VALUES (217, 85);
INSERT INTO comment_like VALUES (225, 66);
INSERT INTO comment_like VALUES (925, 11);
INSERT INTO comment_like VALUES (596, 52);
INSERT INTO comment_like VALUES (269, 95);
INSERT INTO comment_like VALUES (413, 73);
INSERT INTO comment_like VALUES (120, 54);
INSERT INTO comment_like VALUES (291, 37);
INSERT INTO comment_like VALUES (395, 53);
INSERT INTO comment_like VALUES (573, 22);
INSERT INTO comment_like VALUES (388, 65);
INSERT INTO comment_like VALUES (591, 26);
INSERT INTO comment_like VALUES (871, 76);
INSERT INTO comment_like VALUES (777, 79);
INSERT INTO comment_like VALUES (230, 98);
INSERT INTO comment_like VALUES (317, 60);
INSERT INTO comment_like VALUES (96, 96);
INSERT INTO comment_like VALUES (409, 22);
INSERT INTO comment_like VALUES (838, 54);
INSERT INTO comment_like VALUES (375, 73);
INSERT INTO comment_like VALUES (997, 94);
INSERT INTO comment_like VALUES (632, 15);
INSERT INTO comment_like VALUES (90, 77);
INSERT INTO comment_like VALUES (804, 45);
INSERT INTO comment_like VALUES (84, 92);
INSERT INTO comment_like VALUES (882, 60);
INSERT INTO comment_like VALUES (977, 30);
INSERT INTO comment_like VALUES (260, 16);
INSERT INTO comment_like VALUES (147, 95);
INSERT INTO comment_like VALUES (278, 75);
INSERT INTO comment_like VALUES (227, 84);
INSERT INTO comment_like VALUES (749, 55);
INSERT INTO comment_like VALUES (434, 70);
INSERT INTO comment_like VALUES (161, 48);
INSERT INTO comment_like VALUES (4, 51);
INSERT INTO comment_like VALUES (82, 86);
INSERT INTO comment_like VALUES (861, 37);
INSERT INTO comment_like VALUES (160, 38);
INSERT INTO comment_like VALUES (860, 6);
INSERT INTO comment_like VALUES (273, 76);
INSERT INTO comment_like VALUES (60, 55);
INSERT INTO comment_like VALUES (349, 53);
INSERT INTO comment_like VALUES (286, 81);
INSERT INTO comment_like VALUES (103, 18);
INSERT INTO comment_like VALUES (888, 26);
INSERT INTO comment_like VALUES (577, 64);
INSERT INTO comment_like VALUES (387, 71);
INSERT INTO comment_like VALUES (244, 93);
INSERT INTO comment_like VALUES (930, 7);
INSERT INTO comment_like VALUES (145, 85);
INSERT INTO comment_like VALUES (571, 85);
INSERT INTO comment_like VALUES (342, 16);
INSERT INTO comment_like VALUES (169, 25);
INSERT INTO comment_like VALUES (677, 41);
INSERT INTO comment_like VALUES (286, 17);
INSERT INTO comment_like VALUES (310, 44);
INSERT INTO comment_like VALUES (694, 60);
INSERT INTO comment_like VALUES (955, 9);
INSERT INTO comment_like VALUES (727, 61);
INSERT INTO comment_like VALUES (731, 6);
INSERT INTO comment_like VALUES (667, 57);
INSERT INTO comment_like VALUES (174, 59);
INSERT INTO comment_like VALUES (151, 86);
INSERT INTO comment_like VALUES (784, 58);
INSERT INTO comment_like VALUES (814, 60);
INSERT INTO comment_like VALUES (52, 68);
INSERT INTO comment_like VALUES (110, 39);
INSERT INTO comment_like VALUES (101, 73);
INSERT INTO comment_like VALUES (383, 64);
INSERT INTO comment_like VALUES (291, 31);
INSERT INTO comment_like VALUES (599, 60);
INSERT INTO comment_like VALUES (865, 88);
INSERT INTO comment_like VALUES (218, 73);
INSERT INTO comment_like VALUES (297, 54);
INSERT INTO comment_like VALUES (928, 19);
INSERT INTO comment_like VALUES (254, 52);
INSERT INTO comment_like VALUES (827, 31);
INSERT INTO comment_like VALUES (855, 94);
INSERT INTO comment_like VALUES (784, 11);
INSERT INTO comment_like VALUES (620, 29);
INSERT INTO comment_like VALUES (380, 12);
INSERT INTO comment_like VALUES (845, 48);
INSERT INTO comment_like VALUES (725, 30);
INSERT INTO comment_like VALUES (762, 90);
INSERT INTO comment_like VALUES (272, 34);
INSERT INTO comment_like VALUES (281, 62);
INSERT INTO comment_like VALUES (654, 98);
INSERT INTO comment_like VALUES (662, 59);
INSERT INTO comment_like VALUES (859, 58);
INSERT INTO comment_like VALUES (915, 55);
INSERT INTO comment_like VALUES (765, 84);
INSERT INTO comment_like VALUES (186, 14);
INSERT INTO comment_like VALUES (803, 17);
INSERT INTO comment_like VALUES (557, 42);
INSERT INTO comment_like VALUES (477, 16);
INSERT INTO comment_like VALUES (22, 96);
INSERT INTO comment_like VALUES (117, 52);
INSERT INTO comment_like VALUES (78, 4);
INSERT INTO comment_like VALUES (146, 66);
INSERT INTO comment_like VALUES (751, 14);
INSERT INTO comment_like VALUES (715, 93);
INSERT INTO comment_like VALUES (466, 84);
INSERT INTO comment_like VALUES (413, 33);
INSERT INTO comment_like VALUES (40, 88);
INSERT INTO comment_like VALUES (551, 84);
INSERT INTO comment_like VALUES (230, 3);
INSERT INTO comment_like VALUES (181, 3);
INSERT INTO comment_like VALUES (694, 36);
INSERT INTO comment_like VALUES (394, 52);
INSERT INTO comment_like VALUES (980, 57);
INSERT INTO comment_like VALUES (130, 17);
INSERT INTO comment_like VALUES (953, 91);
INSERT INTO comment_like VALUES (612, 6);
INSERT INTO comment_like VALUES (34, 11);
INSERT INTO comment_like VALUES (307, 23);
INSERT INTO comment_like VALUES (362, 66);
INSERT INTO comment_like VALUES (694, 85);
INSERT INTO comment_like VALUES (813, 23);
INSERT INTO comment_like VALUES (559, 6);
INSERT INTO comment_like VALUES (354, 10);
INSERT INTO comment_like VALUES (505, 46);
INSERT INTO comment_like VALUES (173, 63);
INSERT INTO comment_like VALUES (464, 51);
INSERT INTO comment_like VALUES (508, 11);
INSERT INTO comment_like VALUES (470, 12);
INSERT INTO comment_like VALUES (954, 43);
INSERT INTO comment_like VALUES (962, 95);
INSERT INTO comment_like VALUES (127, 81);
INSERT INTO comment_like VALUES (5, 50);
INSERT INTO comment_like VALUES (206, 9);
INSERT INTO comment_like VALUES (368, 13);
INSERT INTO comment_like VALUES (203, 2);
INSERT INTO comment_like VALUES (681, 99);
INSERT INTO comment_like VALUES (641, 36);
INSERT INTO comment_like VALUES (742, 90);
INSERT INTO comment_like VALUES (26, 7);
INSERT INTO comment_like VALUES (135, 21);
INSERT INTO comment_like VALUES (526, 26);
INSERT INTO comment_like VALUES (227, 73);
INSERT INTO comment_like VALUES (708, 51);
INSERT INTO comment_like VALUES (527, 72);
INSERT INTO comment_like VALUES (307, 41);
INSERT INTO comment_like VALUES (906, 39);
INSERT INTO comment_like VALUES (844, 1);
INSERT INTO comment_like VALUES (51, 80);
INSERT INTO comment_like VALUES (82, 5);
INSERT INTO comment_like VALUES (397, 82);
INSERT INTO comment_like VALUES (182, 67);
INSERT INTO comment_like VALUES (991, 61);
INSERT INTO comment_like VALUES (566, 64);
INSERT INTO comment_like VALUES (71, 50);
INSERT INTO comment_like VALUES (222, 2);
INSERT INTO comment_like VALUES (960, 99);
INSERT INTO comment_like VALUES (990, 64);
INSERT INTO comment_like VALUES (728, 100);
INSERT INTO comment_like VALUES (947, 74);
INSERT INTO comment_like VALUES (68, 39);
INSERT INTO comment_like VALUES (543, 87);
INSERT INTO comment_like VALUES (340, 46);
INSERT INTO comment_like VALUES (724, 3);
INSERT INTO comment_like VALUES (800, 75);
INSERT INTO comment_like VALUES (537, 67);
INSERT INTO comment_like VALUES (267, 19);
INSERT INTO comment_like VALUES (248, 57);
INSERT INTO comment_like VALUES (194, 7);
INSERT INTO comment_like VALUES (237, 2);
INSERT INTO comment_like VALUES (292, 53);
INSERT INTO comment_like VALUES (879, 9);
INSERT INTO comment_like VALUES (923, 92);
INSERT INTO comment_like VALUES (484, 51);
INSERT INTO comment_like VALUES (835, 42);
INSERT INTO comment_like VALUES (564, 15);
INSERT INTO comment_like VALUES (451, 37);
INSERT INTO comment_like VALUES (779, 7);
INSERT INTO comment_like VALUES (891, 12);
INSERT INTO comment_like VALUES (486, 88);
INSERT INTO comment_like VALUES (274, 77);
INSERT INTO comment_like VALUES (822, 42);
INSERT INTO comment_like VALUES (68, 74);
INSERT INTO comment_like VALUES (796, 79);
INSERT INTO comment_like VALUES (798, 36);
INSERT INTO comment_like VALUES (85, 23);
INSERT INTO comment_like VALUES (690, 44);
INSERT INTO comment_like VALUES (443, 97);
INSERT INTO comment_like VALUES (667, 73);
INSERT INTO comment_like VALUES (417, 12);
INSERT INTO comment_like VALUES (603, 65);
INSERT INTO comment_like VALUES (984, 6);
INSERT INTO comment_like VALUES (393, 58);
INSERT INTO comment_like VALUES (84, 80);
INSERT INTO comment_like VALUES (28, 38);
INSERT INTO comment_like VALUES (788, 87);
INSERT INTO comment_like VALUES (299, 50);
INSERT INTO comment_like VALUES (970, 26);
INSERT INTO comment_like VALUES (977, 89);
INSERT INTO comment_like VALUES (198, 5);
INSERT INTO comment_like VALUES (600, 67);
INSERT INTO comment_like VALUES (400, 12);
INSERT INTO comment_like VALUES (280, 52);
INSERT INTO comment_like VALUES (9, 24);
INSERT INTO comment_like VALUES (889, 9);
INSERT INTO comment_like VALUES (156, 28);
INSERT INTO comment_like VALUES (827, 28);
INSERT INTO comment_like VALUES (175, 24);
INSERT INTO comment_like VALUES (647, 91);
INSERT INTO comment_like VALUES (311, 32);
INSERT INTO comment_like VALUES (854, 79);
INSERT INTO comment_like VALUES (892, 29);
INSERT INTO comment_like VALUES (971, 76);
INSERT INTO comment_like VALUES (492, 11);
INSERT INTO comment_like VALUES (556, 71);
INSERT INTO comment_like VALUES (802, 37);
INSERT INTO comment_like VALUES (507, 54);
INSERT INTO comment_like VALUES (383, 95);
INSERT INTO comment_like VALUES (516, 52);
INSERT INTO comment_like VALUES (428, 61);
INSERT INTO comment_like VALUES (436, 5);
INSERT INTO comment_like VALUES (388, 21);
INSERT INTO comment_like VALUES (136, 2);
INSERT INTO comment_like VALUES (790, 7);
INSERT INTO comment_like VALUES (250, 85);
INSERT INTO comment_like VALUES (320, 68);
INSERT INTO comment_like VALUES (516, 70);
INSERT INTO comment_like VALUES (636, 83);
INSERT INTO comment_like VALUES (838, 19);
INSERT INTO comment_like VALUES (855, 11);
INSERT INTO comment_like VALUES (956, 45);
INSERT INTO comment_like VALUES (521, 4);
INSERT INTO comment_like VALUES (293, 55);
INSERT INTO comment_like VALUES (991, 46);
INSERT INTO comment_like VALUES (43, 61);
INSERT INTO comment_like VALUES (25, 50);
INSERT INTO comment_like VALUES (141, 43);
INSERT INTO comment_like VALUES (461, 11);
INSERT INTO comment_like VALUES (980, 15);
INSERT INTO comment_like VALUES (829, 2);
INSERT INTO comment_like VALUES (510, 17);
INSERT INTO comment_like VALUES (729, 86);
INSERT INTO comment_like VALUES (163, 42);
INSERT INTO comment_like VALUES (166, 26);
INSERT INTO comment_like VALUES (513, 24);
INSERT INTO comment_like VALUES (866, 28);
INSERT INTO comment_like VALUES (457, 28);
INSERT INTO comment_like VALUES (958, 10);
INSERT INTO comment_like VALUES (556, 15);
INSERT INTO comment_like VALUES (131, 22);
INSERT INTO comment_like VALUES (497, 73);
INSERT INTO comment_like VALUES (730, 28);
INSERT INTO comment_like VALUES (654, 47);
INSERT INTO comment_like VALUES (225, 19);
INSERT INTO comment_like VALUES (150, 6);
INSERT INTO comment_like VALUES (591, 10);
INSERT INTO comment_like VALUES (473, 91);
INSERT INTO comment_like VALUES (542, 65);
INSERT INTO comment_like VALUES (581, 81);
INSERT INTO comment_like VALUES (119, 46);
INSERT INTO comment_like VALUES (676, 24);
INSERT INTO comment_like VALUES (451, 70);
INSERT INTO comment_like VALUES (330, 15);
INSERT INTO comment_like VALUES (98, 8);
INSERT INTO comment_like VALUES (491, 3);
INSERT INTO comment_like VALUES (259, 40);
INSERT INTO comment_like VALUES (872, 30);
INSERT INTO comment_like VALUES (230, 55);
INSERT INTO comment_like VALUES (271, 34);
INSERT INTO comment_like VALUES (318, 27);
INSERT INTO comment_like VALUES (975, 29);
INSERT INTO comment_like VALUES (37, 46);
INSERT INTO comment_like VALUES (966, 53);
INSERT INTO comment_like VALUES (435, 11);
INSERT INTO comment_like VALUES (784, 82);
INSERT INTO comment_like VALUES (125, 74);
INSERT INTO comment_like VALUES (897, 99);
INSERT INTO comment_like VALUES (14, 67);
INSERT INTO comment_like VALUES (287, 56);
INSERT INTO comment_like VALUES (932, 41);
INSERT INTO comment_like VALUES (437, 97);
INSERT INTO comment_like VALUES (817, 93);
INSERT INTO comment_like VALUES (10, 62);
INSERT INTO comment_like VALUES (157, 48);
INSERT INTO comment_like VALUES (421, 64);
INSERT INTO comment_like VALUES (795, 25);
INSERT INTO comment_like VALUES (696, 94);
INSERT INTO comment_like VALUES (897, 42);
INSERT INTO comment_like VALUES (914, 28);
INSERT INTO comment_like VALUES (609, 27);
INSERT INTO comment_like VALUES (48, 65);
INSERT INTO comment_like VALUES (117, 39);
INSERT INTO comment_like VALUES (419, 56);
INSERT INTO comment_like VALUES (77, 13);
INSERT INTO comment_like VALUES (832, 15);
INSERT INTO comment_like VALUES (720, 51);
INSERT INTO comment_like VALUES (87, 99);
INSERT INTO comment_like VALUES (53, 7);
INSERT INTO comment_like VALUES (552, 95);
INSERT INTO comment_like VALUES (293, 100);
INSERT INTO comment_like VALUES (931, 68);
INSERT INTO comment_like VALUES (579, 10);
INSERT INTO comment_like VALUES (256, 68);
INSERT INTO comment_like VALUES (548, 52);
INSERT INTO comment_like VALUES (449, 28);
INSERT INTO comment_like VALUES (16, 38);
INSERT INTO comment_like VALUES (887, 47);
INSERT INTO comment_like VALUES (251, 62);
INSERT INTO comment_like VALUES (960, 65);
INSERT INTO comment_like VALUES (207, 96);
INSERT INTO comment_like VALUES (544, 12);
INSERT INTO comment_like VALUES (462, 18);
INSERT INTO comment_like VALUES (330, 77);
INSERT INTO comment_like VALUES (291, 19);
INSERT INTO comment_like VALUES (431, 28);
INSERT INTO comment_like VALUES (481, 100);
INSERT INTO comment_like VALUES (917, 57);
INSERT INTO comment_like VALUES (310, 65);
INSERT INTO comment_like VALUES (135, 71);
INSERT INTO comment_like VALUES (224, 24);
INSERT INTO comment_like VALUES (170, 42);
INSERT INTO comment_like VALUES (467, 46);
INSERT INTO comment_like VALUES (272, 98);
INSERT INTO comment_like VALUES (373, 46);
INSERT INTO comment_like VALUES (188, 48);
INSERT INTO comment_like VALUES (670, 6);
INSERT INTO comment_like VALUES (372, 19);
INSERT INTO comment_like VALUES (563, 83);
INSERT INTO comment_like VALUES (245, 23);
INSERT INTO comment_like VALUES (189, 25);
INSERT INTO comment_like VALUES (815, 46);
INSERT INTO comment_like VALUES (201, 77);
INSERT INTO comment_like VALUES (744, 84);
INSERT INTO comment_like VALUES (825, 42);
INSERT INTO comment_like VALUES (554, 22);
INSERT INTO comment_like VALUES (606, 78);
INSERT INTO comment_like VALUES (333, 15);
INSERT INTO comment_like VALUES (192, 33);
INSERT INTO comment_like VALUES (73, 48);
INSERT INTO comment_like VALUES (243, 93);
INSERT INTO comment_like VALUES (140, 7);
INSERT INTO comment_like VALUES (671, 27);
INSERT INTO comment_like VALUES (43, 35);
INSERT INTO comment_like VALUES (425, 65);
INSERT INTO comment_like VALUES (763, 26);
INSERT INTO comment_like VALUES (159, 38);
INSERT INTO comment_like VALUES (914, 40);
INSERT INTO comment_like VALUES (845, 78);
INSERT INTO comment_like VALUES (105, 87);
INSERT INTO comment_like VALUES (704, 24);
INSERT INTO comment_like VALUES (180, 32);
INSERT INTO comment_like VALUES (818, 90);
INSERT INTO comment_like VALUES (675, 80);
INSERT INTO comment_like VALUES (89, 88);
INSERT INTO comment_like VALUES (7, 24);
INSERT INTO comment_like VALUES (672, 30);
INSERT INTO comment_like VALUES (754, 14);
INSERT INTO comment_like VALUES (227, 96);
INSERT INTO comment_like VALUES (273, 86);
INSERT INTO comment_like VALUES (347, 78);
INSERT INTO comment_like VALUES (563, 29);
INSERT INTO comment_like VALUES (396, 70);
INSERT INTO comment_like VALUES (113, 69);
INSERT INTO comment_like VALUES (449, 20);
INSERT INTO comment_like VALUES (145, 57);
INSERT INTO comment_like VALUES (726, 18);
INSERT INTO comment_like VALUES (110, 30);
INSERT INTO comment_like VALUES (980, 96);
INSERT INTO comment_like VALUES (662, 72);
INSERT INTO comment_like VALUES (267, 82);
INSERT INTO comment_like VALUES (498, 77);
INSERT INTO comment_like VALUES (875, 32);
INSERT INTO comment_like VALUES (613, 53);
INSERT INTO comment_like VALUES (810, 36);
INSERT INTO comment_like VALUES (821, 68);
INSERT INTO comment_like VALUES (52, 2);
INSERT INTO comment_like VALUES (466, 27);
INSERT INTO comment_like VALUES (553, 49);
INSERT INTO comment_like VALUES (558, 3);
INSERT INTO comment_like VALUES (560, 69);
INSERT INTO comment_like VALUES (143, 49);
INSERT INTO comment_like VALUES (852, 48);
INSERT INTO comment_like VALUES (994, 40);
INSERT INTO comment_like VALUES (984, 16);
INSERT INTO comment_like VALUES (989, 45);
INSERT INTO comment_like VALUES (975, 35);
INSERT INTO comment_like VALUES (993, 90);
INSERT INTO comment_like VALUES (346, 31);
INSERT INTO comment_like VALUES (105, 18);
INSERT INTO comment_like VALUES (435, 38);
INSERT INTO comment_like VALUES (675, 5);
INSERT INTO comment_like VALUES (436, 55);
INSERT INTO comment_like VALUES (779, 3);
INSERT INTO comment_like VALUES (816, 94);
INSERT INTO comment_like VALUES (604, 94);
INSERT INTO comment_like VALUES (927, 1);
INSERT INTO comment_like VALUES (144, 98);
INSERT INTO comment_like VALUES (515, 31);
INSERT INTO comment_like VALUES (354, 99);
INSERT INTO comment_like VALUES (816, 27);
INSERT INTO comment_like VALUES (293, 10);
INSERT INTO comment_like VALUES (848, 22);
INSERT INTO comment_like VALUES (866, 95);
INSERT INTO comment_like VALUES (656, 58);
INSERT INTO comment_like VALUES (97, 83);
INSERT INTO comment_like VALUES (567, 87);
INSERT INTO comment_like VALUES (834, 56);
INSERT INTO comment_like VALUES (767, 19);
INSERT INTO comment_like VALUES (531, 27);
INSERT INTO comment_like VALUES (617, 31);
INSERT INTO comment_like VALUES (750, 61);
INSERT INTO comment_like VALUES (280, 24);
INSERT INTO comment_like VALUES (829, 30);
INSERT INTO comment_like VALUES (471, 8);
INSERT INTO comment_like VALUES (323, 60);
INSERT INTO comment_like VALUES (766, 2);
INSERT INTO comment_like VALUES (21, 51);
INSERT INTO comment_like VALUES (330, 26);
INSERT INTO comment_like VALUES (839, 51);
INSERT INTO comment_like VALUES (682, 53);
INSERT INTO comment_like VALUES (80, 95);
INSERT INTO comment_like VALUES (421, 81);
INSERT INTO comment_like VALUES (421, 96);


--
-- Data for Name: country; Type: TABLE DATA; Schema: public; Owner: lbaw1614
--

INSERT INTO country VALUES (1, 'Portugal');
INSERT INTO country VALUES (3, 'Spain');
INSERT INTO country VALUES (2, 'France');
INSERT INTO country VALUES (4, 'Netherlands');
INSERT INTO country VALUES (5, 'Morocco');
INSERT INTO country VALUES (6, 'Argentina');
INSERT INTO country VALUES (7, 'Nigeria');
INSERT INTO country VALUES (8, 'USA');
INSERT INTO country VALUES (9, 'China');
INSERT INTO country VALUES (10, 'Cameroon');


--
-- Data for Name: file; Type: TABLE DATA; Schema: public; Owner: lbaw1614
--

INSERT INTO file VALUES (1, '2017-07-27 00:00:00+01', 24, 25, 'sapien', 'duis ac nibh.iges');
INSERT INTO file VALUES (2, '2018-01-24 00:00:00+00', 97, 9, 'luctus tincidunt nulla mollis', 'diam cras.ima');
INSERT INTO file VALUES (3, '2016-05-29 00:00:00+01', 15, 23, 'fusce', 'curabitur gravida nisi.zip');
INSERT INTO file VALUES (4, '2016-08-09 00:00:00+01', 75, 16, 'platea dictumst morbi vestibulum', 'tristique est.omc');
INSERT INTO file VALUES (5, '2017-08-13 00:00:00+01', 87, 17, 'egestas metus aenean', 'ligula sit.mcd');
INSERT INTO file VALUES (6, '2016-10-26 00:00:00+01', 83, 29, 'id mauris', 'felis sed lacus.moov');
INSERT INTO file VALUES (7, '2016-07-14 00:00:00+01', 86, 22, 'ut', 'platea dictumst.deepv');
INSERT INTO file VALUES (8, '2018-01-15 00:00:00+00', 79, 6, 'mi sit', 'tellus in.fli');
INSERT INTO file VALUES (9, '2016-09-16 00:00:00+01', 30, 4, 'aliquet maecenas', 'enim.bin');
INSERT INTO file VALUES (10, '2016-06-08 00:00:00+01', 72, 16, 'justo', 'morbi vel lectus.vrml');
INSERT INTO file VALUES (11, '2016-03-31 00:00:00+01', 39, 14, 'tortor sollicitudin', 'donec posuere metus.ima');
INSERT INTO file VALUES (12, '2017-10-11 00:00:00+01', 9, 19, 'dictumst etiam faucibus', 'blandit lacinia.bz');
INSERT INTO file VALUES (13, '2017-07-03 00:00:00+01', 11, 30, 'blandit non', 'nec sem duis.pm');
INSERT INTO file VALUES (14, '2018-01-28 00:00:00+00', 24, 2, 'vulputate luctus cum', 'in.mid');
INSERT INTO file VALUES (15, '2017-01-05 00:00:00+00', 69, 28, 'ipsum integer a nibh', 'sit amet nunc.voc');
INSERT INTO file VALUES (16, '2017-12-20 00:00:00+00', 15, 30, 'in ante vestibulum ante', 'consequat ut nulla.boz');
INSERT INTO file VALUES (17, '2016-12-28 00:00:00+00', 100, 3, 'volutpat in', 'facilisi cras non.for');
INSERT INTO file VALUES (18, '2016-08-07 00:00:00+01', 75, 22, 'cum', 'ac est lacinia.tcsh');
INSERT INTO file VALUES (19, '2017-08-31 00:00:00+01', 94, 30, 'non', 'nibh.es');
INSERT INTO file VALUES (20, '2017-03-05 00:00:00+00', 83, 5, 'nonummy maecenas', 'congue.tbk');
INSERT INTO file VALUES (21, '2017-12-15 00:00:00+00', 33, 15, 'mus vivamus', 'fusce posuere.xpm');
INSERT INTO file VALUES (22, '2017-02-02 00:00:00+00', 46, 6, 'dui luctus rutrum nulla', 'platea dictumst aliquam.ra');
INSERT INTO file VALUES (23, '2017-04-03 00:00:00+01', 52, 7, 'eu massa', 'quis.ccad');
INSERT INTO file VALUES (24, '2017-12-31 00:00:00+00', 54, 12, 'aliquet pulvinar sed', 'donec semper.wrz');
INSERT INTO file VALUES (25, '2017-08-28 00:00:00+01', 35, 15, 'id', 'ac lobortis.sol');
INSERT INTO file VALUES (26, '2018-03-07 00:00:00+00', 36, 5, 'posuere cubilia curae nulla', 'duis faucibus.vivo');
INSERT INTO file VALUES (27, '2017-12-09 00:00:00+00', 34, 25, 'pede posuere nonummy integer', 'dis.xlw');
INSERT INTO file VALUES (28, '2018-01-29 00:00:00+00', 64, 10, 'nunc nisl', 'cras.smi');
INSERT INTO file VALUES (29, '2017-07-27 00:00:00+01', 43, 24, 'in hac habitasse platea', 'est.wp5');
INSERT INTO file VALUES (30, '2017-04-16 00:00:00+01', 59, 4, 'ut rhoncus aliquet', 'turpis donec.texinfo');
INSERT INTO file VALUES (31, '2016-12-07 00:00:00+00', 29, 11, 'nulla justo', 'sed lacus.stl');
INSERT INTO file VALUES (32, '2016-07-12 00:00:00+01', 9, 24, 'convallis nunc proin at', 'nonummy.cdf');
INSERT INTO file VALUES (33, '2018-01-31 00:00:00+00', 15, 10, 'quisque ut erat curabitur', 'volutpat sapien arcu.jpe');
INSERT INTO file VALUES (34, '2016-10-28 00:00:00+01', 25, 4, 'porta', 'sem sed sagittis.xmz');
INSERT INTO file VALUES (35, '2017-08-05 00:00:00+01', 3, 23, 'orci luctus', 'erat.mzz');
INSERT INTO file VALUES (36, '2017-10-28 00:00:00+01', 95, 9, 'nonummy', 'est lacinia.imap');
INSERT INTO file VALUES (37, '2017-06-01 00:00:00+01', 45, 13, 'enim', 'nonummy.ppt');
INSERT INTO file VALUES (38, '2017-05-15 00:00:00+01', 89, 26, 'vestibulum velit id', 'luctus nec.xls');
INSERT INTO file VALUES (39, '2017-05-26 00:00:00+01', 81, 30, 'turpis a pede', 'sapien iaculis congue.3dmf');
INSERT INTO file VALUES (40, '2017-04-07 00:00:00+01', 84, 11, 'tempus vivamus in felis', 'eget eleifend luctus.dwf');
INSERT INTO file VALUES (41, '2017-04-17 00:00:00+01', 75, 13, 'vulputate vitae', 'quis justo maecenas.asx');
INSERT INTO file VALUES (42, '2017-11-13 00:00:00+00', 94, 20, 'non quam nec', 'ut.aip');
INSERT INTO file VALUES (43, '2017-09-12 00:00:00+01', 72, 2, 'at turpis a pede', 'nulla.qd3d');
INSERT INTO file VALUES (44, '2016-05-13 00:00:00+01', 45, 7, 'ante ipsum primis in', 'aenean.vos');
INSERT INTO file VALUES (45, '2017-08-12 00:00:00+01', 12, 7, 'vestibulum', 'commodo.ima');
INSERT INTO file VALUES (46, '2017-03-16 00:00:00+00', 10, 17, 'amet sapien', 'convallis.sh');
INSERT INTO file VALUES (47, '2017-05-22 00:00:00+01', 4, 23, 'id ligula suspendisse ornare', 'ac nulla.bm');
INSERT INTO file VALUES (48, '2016-07-10 00:00:00+01', 61, 9, 'phasellus id sapien in', 'faucibus cursus.vos');
INSERT INTO file VALUES (49, '2017-03-30 00:00:00+01', 52, 16, 'ut odio', 'donec ut.xlb');
INSERT INTO file VALUES (50, '2017-11-20 00:00:00+00', 70, 21, 'varius ut', 'mi.ani');
INSERT INTO file VALUES (51, '2017-05-08 00:00:00+01', 61, 25, 'primis in', 'pretium iaculis diam.tcl');
INSERT INTO file VALUES (52, '2018-03-16 00:00:00+00', 56, 19, 'ut dolor morbi', 'arcu adipiscing.log');
INSERT INTO file VALUES (53, '2017-02-28 00:00:00+00', 17, 20, 'luctus et ultrices posuere', 'curabitur.hh');
INSERT INTO file VALUES (54, '2017-07-26 00:00:00+01', 6, 1, 'ipsum primis', 'id nulla.cdf');
INSERT INTO file VALUES (55, '2017-02-06 00:00:00+00', 89, 6, 'tortor sollicitudin mi sit', 'sollicitudin mi.pbm');
INSERT INTO file VALUES (56, '2017-12-19 00:00:00+00', 19, 27, 'in', 'mus vivamus.rng');
INSERT INTO file VALUES (57, '2016-04-17 00:00:00+01', 88, 9, 'bibendum', 'natoque penatibus.mid');
INSERT INTO file VALUES (58, '2016-05-14 00:00:00+01', 77, 30, 'in sagittis dui', 'volutpat.bmp');
INSERT INTO file VALUES (59, '2018-01-05 00:00:00+00', 50, 20, 'quisque', 'lectus pellentesque.cpt');
INSERT INTO file VALUES (60, '2017-06-21 00:00:00+01', 71, 21, 'tempus vel pede', 'ridiculus mus vivamus.zip');
INSERT INTO file VALUES (61, '2018-01-27 00:00:00+00', 82, 8, 'lacus morbi', 'ut.list');
INSERT INTO file VALUES (62, '2017-07-11 00:00:00+01', 95, 23, 'rhoncus aliquet pulvinar', 'fusce.css');
INSERT INTO file VALUES (63, '2018-01-17 00:00:00+00', 99, 7, 'ac tellus semper interdum', 'donec quis.xmz');
INSERT INTO file VALUES (64, '2017-07-04 00:00:00+01', 29, 27, 'in faucibus orci', 'vitae nisl.hgl');
INSERT INTO file VALUES (65, '2016-10-15 00:00:00+01', 63, 29, 'ut', 'congue risus semper.bin');
INSERT INTO file VALUES (66, '2017-09-24 00:00:00+01', 74, 11, 'dui maecenas tristique est', 'morbi quis.uri');
INSERT INTO file VALUES (67, '2017-08-21 00:00:00+01', 98, 26, 'imperdiet nullam orci pede', 'orci luctus.gif');
INSERT INTO file VALUES (68, '2017-11-08 00:00:00+00', 2, 1, 'congue elementum in hac', 'in ante.fli');
INSERT INTO file VALUES (69, '2016-10-11 00:00:00+01', 19, 18, 'quisque', 'felis.art');
INSERT INTO file VALUES (70, '2016-06-04 00:00:00+01', 38, 4, 'in hac habitasse platea', 'libero non mattis.3dm');
INSERT INTO file VALUES (71, '2017-10-31 00:00:00+00', 54, 15, 'cras non velit nec', 'sapien in.ivy');
INSERT INTO file VALUES (72, '2017-08-12 00:00:00+01', 5, 9, 'sociis natoque penatibus et', 'commodo placerat.part');
INSERT INTO file VALUES (73, '2016-07-30 00:00:00+01', 60, 14, 'id pretium iaculis diam', 'sapien varius.doc');
INSERT INTO file VALUES (74, '2016-06-12 00:00:00+01', 86, 11, 'ipsum integer', 'fusce congue diam.aifc');
INSERT INTO file VALUES (75, '2016-08-29 00:00:00+01', 96, 28, 'porttitor lacus at', 'pede justo.ins');
INSERT INTO file VALUES (76, '2017-11-30 00:00:00+00', 10, 16, 'pretium', 'integer pede justo.sdr');
INSERT INTO file VALUES (77, '2016-07-16 00:00:00+01', 16, 8, 'laoreet ut', 'nulla integer.prt');
INSERT INTO file VALUES (78, '2017-07-03 00:00:00+01', 84, 15, 'in tempor turpis', 'vulputate.jcm');
INSERT INTO file VALUES (79, '2016-07-21 00:00:00+01', 6, 8, 'quis orci nullam', 'ligula.skd');
INSERT INTO file VALUES (80, '2016-05-03 00:00:00+01', 26, 20, 'dolor vel', 'eget.wp5');
INSERT INTO file VALUES (81, '2018-02-25 00:00:00+00', 86, 16, 'in felis eu sapien', 'ullamcorper.svr');
INSERT INTO file VALUES (82, '2018-03-07 00:00:00+00', 86, 20, 'et ultrices posuere cubilia', 'dictumst etiam.vmd');
INSERT INTO file VALUES (83, '2016-11-25 00:00:00+00', 25, 17, 'id luctus', 'neque.js');
INSERT INTO file VALUES (84, '2018-01-22 00:00:00+00', 3, 25, 'vestibulum rutrum', 'potenti in.uri');
INSERT INTO file VALUES (85, '2017-06-07 00:00:00+01', 47, 9, 'metus sapien ut nunc', 'vestibulum proin.stl');
INSERT INTO file VALUES (86, '2017-12-19 00:00:00+00', 92, 1, 'nam', 'nibh ligula nec.zoo');
INSERT INTO file VALUES (87, '2016-07-02 00:00:00+01', 21, 13, 'felis sed lacus morbi', 'et.rm');
INSERT INTO file VALUES (88, '2017-12-23 00:00:00+00', 34, 2, 'nisl', 'eget eros.hqx');
INSERT INTO file VALUES (89, '2017-03-21 00:00:00+00', 13, 14, 'convallis morbi odio odio', 'fusce consequat.svr');
INSERT INTO file VALUES (90, '2017-12-10 00:00:00+00', 12, 3, 'potenti in', 'volutpat eleifend.vos');
INSERT INTO file VALUES (91, '2017-08-16 00:00:00+01', 99, 19, 'eu', 'duis consequat dui.igs');
INSERT INTO file VALUES (92, '2017-03-21 00:00:00+00', 48, 23, 'donec posuere metus', 'elementum in.mv');
INSERT INTO file VALUES (93, '2016-07-03 00:00:00+01', 59, 28, 'primis in faucibus', 'congue.rmp');
INSERT INTO file VALUES (94, '2017-01-01 00:00:00+00', 58, 10, 'venenatis tristique fusce congue', 'luctus.me');
INSERT INTO file VALUES (95, '2017-02-10 00:00:00+00', 43, 27, 'accumsan odio', 'sem.f90');
INSERT INTO file VALUES (96, '2017-01-16 00:00:00+00', 21, 16, 'amet sapien dignissim', 'non pretium.m3u');
INSERT INTO file VALUES (97, '2016-10-03 00:00:00+01', 88, 13, 'vestibulum sed magna', 'aliquam.mid');
INSERT INTO file VALUES (98, '2016-07-28 00:00:00+01', 96, 17, 'id', 'in ante vestibulum.sh');
INSERT INTO file VALUES (99, '2018-03-14 00:00:00+00', 54, 21, 'amet nunc', 'ultrices.jpe');
INSERT INTO file VALUES (100, '2016-10-18 00:00:00+01', 59, 8, 'congue diam id ornare', 'quis orci.xpm');


--
-- Name: file_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1614
--

SELECT pg_catalog.setval('file_id_seq', 1, false);


--
-- Data for Name: file_meeting; Type: TABLE DATA; Schema: public; Owner: lbaw1614
--

INSERT INTO file_meeting VALUES (76, 18);
INSERT INTO file_meeting VALUES (7, 6);
INSERT INTO file_meeting VALUES (96, 1);
INSERT INTO file_meeting VALUES (74, 18);
INSERT INTO file_meeting VALUES (26, 3);
INSERT INTO file_meeting VALUES (36, 6);
INSERT INTO file_meeting VALUES (67, 15);
INSERT INTO file_meeting VALUES (16, 5);
INSERT INTO file_meeting VALUES (17, 2);
INSERT INTO file_meeting VALUES (15, 15);
INSERT INTO file_meeting VALUES (61, 68);
INSERT INTO file_meeting VALUES (63, 42);
INSERT INTO file_meeting VALUES (76, 18);
INSERT INTO file_meeting VALUES (27, 77);
INSERT INTO file_meeting VALUES (83, 50);
INSERT INTO file_meeting VALUES (34, 81);
INSERT INTO file_meeting VALUES (48, 72);
INSERT INTO file_meeting VALUES (96, 95);
INSERT INTO file_meeting VALUES (69, 50);
INSERT INTO file_meeting VALUES (7, 6);
INSERT INTO file_meeting VALUES (16, 29);
INSERT INTO file_meeting VALUES (98, 24);
INSERT INTO file_meeting VALUES (27, 80);
INSERT INTO file_meeting VALUES (50, 60);
INSERT INTO file_meeting VALUES (96, 1);
INSERT INTO file_meeting VALUES (3, 23);
INSERT INTO file_meeting VALUES (14, 80);
INSERT INTO file_meeting VALUES (38, 96);
INSERT INTO file_meeting VALUES (19, 46);
INSERT INTO file_meeting VALUES (69, 38);
INSERT INTO file_meeting VALUES (54, 59);
INSERT INTO file_meeting VALUES (74, 18);
INSERT INTO file_meeting VALUES (25, 62);
INSERT INTO file_meeting VALUES (26, 3);
INSERT INTO file_meeting VALUES (36, 6);
INSERT INTO file_meeting VALUES (42, 34);
INSERT INTO file_meeting VALUES (19, 36);
INSERT INTO file_meeting VALUES (38, 92);
INSERT INTO file_meeting VALUES (66, 66);
INSERT INTO file_meeting VALUES (3, 49);
INSERT INTO file_meeting VALUES (68, 47);
INSERT INTO file_meeting VALUES (19, 59);
INSERT INTO file_meeting VALUES (21, 62);
INSERT INTO file_meeting VALUES (10, 78);
INSERT INTO file_meeting VALUES (60, 23);
INSERT INTO file_meeting VALUES (22, 75);
INSERT INTO file_meeting VALUES (22, 71);
INSERT INTO file_meeting VALUES (51, 43);
INSERT INTO file_meeting VALUES (67, 15);
INSERT INTO file_meeting VALUES (65, 30);
INSERT INTO file_meeting VALUES (87, 41);
INSERT INTO file_meeting VALUES (97, 28);
INSERT INTO file_meeting VALUES (16, 5);
INSERT INTO file_meeting VALUES (17, 2);
INSERT INTO file_meeting VALUES (15, 15);
INSERT INTO file_meeting VALUES (26, 62);
INSERT INTO file_meeting VALUES (23, 66);
INSERT INTO file_meeting VALUES (86, 96);
INSERT INTO file_meeting VALUES (87, 24);
INSERT INTO file_meeting VALUES (97, 82);


--
-- Data for Name: file_tag; Type: TABLE DATA; Schema: public; Owner: lbaw1614
--

INSERT INTO file_tag VALUES (17, 91);
INSERT INTO file_tag VALUES (17, 62);
INSERT INTO file_tag VALUES (3, 25);
INSERT INTO file_tag VALUES (19, 39);
INSERT INTO file_tag VALUES (19, 12);
INSERT INTO file_tag VALUES (16, 37);
INSERT INTO file_tag VALUES (20, 91);
INSERT INTO file_tag VALUES (12, 49);
INSERT INTO file_tag VALUES (12, 2);
INSERT INTO file_tag VALUES (20, 61);
INSERT INTO file_tag VALUES (7, 1);
INSERT INTO file_tag VALUES (16, 89);
INSERT INTO file_tag VALUES (3, 31);
INSERT INTO file_tag VALUES (13, 75);
INSERT INTO file_tag VALUES (6, 2);
INSERT INTO file_tag VALUES (17, 80);
INSERT INTO file_tag VALUES (17, 57);
INSERT INTO file_tag VALUES (20, 96);
INSERT INTO file_tag VALUES (4, 42);
INSERT INTO file_tag VALUES (16, 28);
INSERT INTO file_tag VALUES (13, 68);
INSERT INTO file_tag VALUES (17, 75);
INSERT INTO file_tag VALUES (5, 48);
INSERT INTO file_tag VALUES (14, 70);
INSERT INTO file_tag VALUES (5, 56);
INSERT INTO file_tag VALUES (6, 82);
INSERT INTO file_tag VALUES (19, 30);
INSERT INTO file_tag VALUES (12, 14);
INSERT INTO file_tag VALUES (3, 80);
INSERT INTO file_tag VALUES (19, 80);
INSERT INTO file_tag VALUES (12, 85);
INSERT INTO file_tag VALUES (11, 75);
INSERT INTO file_tag VALUES (19, 72);
INSERT INTO file_tag VALUES (13, 6);
INSERT INTO file_tag VALUES (17, 5);
INSERT INTO file_tag VALUES (6, 79);
INSERT INTO file_tag VALUES (15, 64);
INSERT INTO file_tag VALUES (16, 5);
INSERT INTO file_tag VALUES (5, 89);
INSERT INTO file_tag VALUES (7, 93);
INSERT INTO file_tag VALUES (11, 38);
INSERT INTO file_tag VALUES (19, 52);
INSERT INTO file_tag VALUES (19, 32);
INSERT INTO file_tag VALUES (7, 56);
INSERT INTO file_tag VALUES (13, 70);
INSERT INTO file_tag VALUES (15, 72);
INSERT INTO file_tag VALUES (8, 38);
INSERT INTO file_tag VALUES (4, 57);
INSERT INTO file_tag VALUES (14, 37);
INSERT INTO file_tag VALUES (6, 55);
INSERT INTO file_tag VALUES (1, 56);
INSERT INTO file_tag VALUES (20, 38);
INSERT INTO file_tag VALUES (19, 47);
INSERT INTO file_tag VALUES (1, 46);
INSERT INTO file_tag VALUES (11, 15);
INSERT INTO file_tag VALUES (17, 12);
INSERT INTO file_tag VALUES (5, 89);
INSERT INTO file_tag VALUES (6, 84);
INSERT INTO file_tag VALUES (20, 49);
INSERT INTO file_tag VALUES (8, 60);
INSERT INTO file_tag VALUES (12, 52);
INSERT INTO file_tag VALUES (2, 17);
INSERT INTO file_tag VALUES (6, 77);
INSERT INTO file_tag VALUES (14, 100);
INSERT INTO file_tag VALUES (5, 61);
INSERT INTO file_tag VALUES (11, 94);
INSERT INTO file_tag VALUES (15, 29);
INSERT INTO file_tag VALUES (11, 42);
INSERT INTO file_tag VALUES (13, 30);
INSERT INTO file_tag VALUES (7, 6);
INSERT INTO file_tag VALUES (16, 58);
INSERT INTO file_tag VALUES (8, 81);
INSERT INTO file_tag VALUES (2, 84);
INSERT INTO file_tag VALUES (8, 33);
INSERT INTO file_tag VALUES (9, 100);
INSERT INTO file_tag VALUES (20, 57);
INSERT INTO file_tag VALUES (7, 85);
INSERT INTO file_tag VALUES (20, 9);
INSERT INTO file_tag VALUES (5, 68);
INSERT INTO file_tag VALUES (17, 75);
INSERT INTO file_tag VALUES (2, 68);
INSERT INTO file_tag VALUES (6, 67);
INSERT INTO file_tag VALUES (19, 14);
INSERT INTO file_tag VALUES (17, 22);
INSERT INTO file_tag VALUES (1, 91);
INSERT INTO file_tag VALUES (11, 5);
INSERT INTO file_tag VALUES (12, 80);
INSERT INTO file_tag VALUES (18, 38);
INSERT INTO file_tag VALUES (15, 13);
INSERT INTO file_tag VALUES (11, 64);
INSERT INTO file_tag VALUES (7, 71);
INSERT INTO file_tag VALUES (16, 79);
INSERT INTO file_tag VALUES (11, 3);
INSERT INTO file_tag VALUES (20, 30);
INSERT INTO file_tag VALUES (6, 54);
INSERT INTO file_tag VALUES (1, 97);
INSERT INTO file_tag VALUES (18, 14);
INSERT INTO file_tag VALUES (2, 58);
INSERT INTO file_tag VALUES (2, 62);
INSERT INTO file_tag VALUES (14, 44);


--
-- Data for Name: forum_post; Type: TABLE DATA; Schema: public; Owner: lbaw1614
--

INSERT INTO forum_post VALUES (82, 'convallis nulla neque libero convallis eget eleifend', '2016-05-26 00:00:00+01', 'gravida nisi at nibh in hac habitasse platea dictumst aliquam', 1, '2018-03-23 00:00:00+00', 62);
INSERT INTO forum_post VALUES (3, 'vel sem sed', '2016-01-07 00:00:00+00', 'eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor', 19, '2017-03-23 00:00:00+00', 57);
INSERT INTO forum_post VALUES (4, 'cras pellentesque volutpat dui maecenas tristique est et tempus semper', '2015-06-14 00:00:00+01', 'ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus vel nulla', 6, '2017-03-23 00:00:00+00', 96);
INSERT INTO forum_post VALUES (5, 'faucibus orci luctus', '2015-12-07 00:00:00+00', 'risus auctor sed tristique in tempus sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in', 6, '2017-03-23 00:00:00+00', 30);
INSERT INTO forum_post VALUES (6, 'pellentesque quisque porta volutpat erat quisque erat', '2016-02-05 00:00:00+00', 'nonummy maecenas tincidunt lacus at velit vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien', 5, '2017-03-23 00:00:00+00', 4);
INSERT INTO forum_post VALUES (7, 'magna vestibulum aliquet ultrices erat tortor', '2016-10-26 00:00:00+01', 'potenti in eleifend quam a odio in hac habitasse platea', 15, '2017-03-23 00:00:00+00', 29);
INSERT INTO forum_post VALUES (8, 'cras in purus eu magna vulputate', '2015-10-13 00:00:00+01', 'duis aliquam convallis nunc proin at turpis a pede posuere', 8, '2017-03-23 00:00:00+00', 79);
INSERT INTO forum_post VALUES (9, 'ut dolor', '2015-10-06 00:00:00+01', 'aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui', 18, '2017-03-23 00:00:00+00', 80);
INSERT INTO forum_post VALUES (10, 'eros viverra eget congue eget semper rutrum nulla', '2016-11-04 00:00:00+00', 'et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet', 16, '2017-03-23 00:00:00+00', 19);
INSERT INTO forum_post VALUES (11, 'donec quis orci', '2015-08-25 00:00:00+01', 'rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla integer pede justo', 4, '2017-03-23 00:00:00+00', 59);
INSERT INTO forum_post VALUES (12, 'volutpat', '2015-08-05 00:00:00+01', 'sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu', 24, '2017-03-23 00:00:00+00', 23);
INSERT INTO forum_post VALUES (13, 'etiam justo etiam pretium iaculis justo in', '2015-11-18 00:00:00+00', 'nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum', 30, '2017-03-23 00:00:00+00', 45);
INSERT INTO forum_post VALUES (14, 'rutrum at lorem integer tincidunt ante vel ipsum', '2015-06-13 00:00:00+01', 'auctor sed tristique in tempus sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit', 10, '2017-03-23 00:00:00+00', 99);
INSERT INTO forum_post VALUES (15, 'semper rutrum nulla', '2016-09-04 00:00:00+01', 'diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor', 2, '2017-03-23 00:00:00+00', 76);
INSERT INTO forum_post VALUES (16, 'libero non mattis pulvinar nulla pede ullamcorper augue', '2016-02-27 00:00:00+00', 'consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar', 28, '2017-03-23 00:00:00+00', 46);
INSERT INTO forum_post VALUES (17, 'arcu adipiscing molestie hendrerit at vulputate vitae', '2016-10-17 00:00:00+01', 'leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac', 9, '2017-03-23 00:00:00+00', 93);
INSERT INTO forum_post VALUES (18, 'fermentum justo nec condimentum neque sapien placerat', '2015-06-09 00:00:00+01', 'aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt', 20, '2017-03-23 00:00:00+00', 99);
INSERT INTO forum_post VALUES (19, 'ullamcorper augue', '2017-02-09 00:00:00+00', 'purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue', 26, '2017-03-23 00:00:00+00', 98);
INSERT INTO forum_post VALUES (20, 'rhoncus aliquet pulvinar sed nisl nunc', '2016-10-25 00:00:00+01', 'ullamcorper purus sit amet nulla quisque arcu libero rutrum ac', 22, '2017-03-23 00:00:00+00', 91);
INSERT INTO forum_post VALUES (21, 'mauris morbi non lectus aliquam sit amet diam', '2015-12-21 00:00:00+00', 'quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae', 18, '2017-03-23 00:00:00+00', 99);
INSERT INTO forum_post VALUES (22, 'interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus', '2016-04-24 00:00:00+01', 'pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur', 8, '2017-03-23 00:00:00+00', 76);
INSERT INTO forum_post VALUES (27, 'vulputate justo in', '2016-04-24 00:00:00+01', 'lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue', 20, '2017-03-25 18:02:17.238303+00', 40);
INSERT INTO forum_post VALUES (26, 'turpis eget', '2016-12-29 00:00:00+00', 'nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum', 4, '2017-03-25 18:04:23.965376+00', 75);
INSERT INTO forum_post VALUES (2, 'consectetuer adipiscing', '2015-06-29 00:00:00+01', 'nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio', 24, '2017-03-25 18:08:10.245174+00', 54);
INSERT INTO forum_post VALUES (23, 'ipsum', '2017-03-12 00:00:00+00', 'posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit', 14, '2017-03-23 00:00:00+00', 96);
INSERT INTO forum_post VALUES (24, 'nibh in quis justo maecenas', '2015-09-07 00:00:00+01', 'est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula', 3, '2017-03-23 00:00:00+00', 55);
INSERT INTO forum_post VALUES (25, 'ante vel ipsum praesent blandit lacinia erat vestibulum sed', '2015-05-30 00:00:00+01', 'maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin', 29, '2017-03-23 00:00:00+00', 17);
INSERT INTO forum_post VALUES (28, 'eget massa tempor convallis nulla neque libero convallis', '2016-09-10 00:00:00+01', 'morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque', 9, '2017-03-23 00:00:00+00', 5);
INSERT INTO forum_post VALUES (29, 'ultrices vel augue vestibulum ante ipsum', '2016-03-21 00:00:00+00', 'ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam', 7, '2017-03-23 00:00:00+00', 46);
INSERT INTO forum_post VALUES (30, 'lobortis', '2016-08-27 00:00:00+01', 'mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis', 15, '2017-03-23 00:00:00+00', 52);
INSERT INTO forum_post VALUES (31, 'maecenas tincidunt lacus at velit vivamus vel nulla eget eros', '2015-08-24 00:00:00+01', 'sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis', 22, '2017-03-23 00:00:00+00', 26);
INSERT INTO forum_post VALUES (32, 'suspendisse accumsan tortor quis turpis sed ante vivamus', '2015-05-15 00:00:00+01', 'morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus', 6, '2017-03-23 00:00:00+00', 49);
INSERT INTO forum_post VALUES (33, 'non quam nec dui luctus', '2016-06-03 00:00:00+01', 'sed tristique in tempus sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat', 19, '2017-03-23 00:00:00+00', 67);
INSERT INTO forum_post VALUES (34, 'hendrerit', '2015-03-29 00:00:00+00', 'rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris', 4, '2017-03-23 00:00:00+00', 13);
INSERT INTO forum_post VALUES (35, 'risus semper porta volutpat quam pede lobortis ligula sit amet', '2015-12-04 00:00:00+00', 'proin eu mi nulla ac enim in tempor turpis nec euismod', 8, '2017-03-23 00:00:00+00', 67);
INSERT INTO forum_post VALUES (36, 'ut dolor morbi', '2015-03-24 00:00:00+00', 'lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris', 13, '2017-03-23 00:00:00+00', 76);
INSERT INTO forum_post VALUES (37, 'accumsan felis', '2017-01-14 00:00:00+00', 'lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor', 18, '2017-03-23 00:00:00+00', 89);
INSERT INTO forum_post VALUES (38, 'ligula pellentesque ultrices phasellus id sapien in sapien iaculis', '2015-12-08 00:00:00+00', 'erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero', 24, '2017-03-23 00:00:00+00', 4);
INSERT INTO forum_post VALUES (39, 'donec quis orci eget orci vehicula condimentum', '2015-07-16 00:00:00+01', 'orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi', 21, '2017-03-23 00:00:00+00', 17);
INSERT INTO forum_post VALUES (40, 'nulla sed accumsan felis ut at dolor quis odio consequat', '2015-12-23 00:00:00+00', 'et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis', 2, '2017-03-23 00:00:00+00', 36);
INSERT INTO forum_post VALUES (41, 'eget tincidunt eget tempus vel pede morbi porttitor', '2015-06-07 00:00:00+01', 'in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin', 17, '2017-03-23 00:00:00+00', 8);
INSERT INTO forum_post VALUES (42, 'blandit ultrices enim', '2017-01-22 00:00:00+00', 'in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum', 22, '2017-03-23 00:00:00+00', 16);
INSERT INTO forum_post VALUES (43, 'integer pede justo lacinia eget tincidunt', '2015-12-13 00:00:00+00', 'quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris', 25, '2017-03-23 00:00:00+00', 55);
INSERT INTO forum_post VALUES (44, 'amet turpis elementum ligula vehicula consequat morbi a', '2015-04-26 00:00:00+01', 'convallis nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi', 3, '2017-03-23 00:00:00+00', 80);
INSERT INTO forum_post VALUES (45, 'nulla pede ullamcorper augue a suscipit nulla elit ac nulla', '2016-10-14 00:00:00+01', 'eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis', 21, '2017-03-23 00:00:00+00', 45);
INSERT INTO forum_post VALUES (46, 'ullamcorper augue a suscipit', '2016-03-07 00:00:00+00', 'mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus', 6, '2017-03-23 00:00:00+00', 8);
INSERT INTO forum_post VALUES (47, 'posuere cubilia curae', '2015-12-25 00:00:00+00', 'sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus', 18, '2017-03-23 00:00:00+00', 24);
INSERT INTO forum_post VALUES (48, 'ultricies eu nibh quisque', '2016-08-27 00:00:00+01', 'eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae', 9, '2017-03-23 00:00:00+00', 78);
INSERT INTO forum_post VALUES (49, 'condimentum curabitur in libero ut massa volutpat', '2016-12-18 00:00:00+00', 'ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at', 23, '2017-03-23 00:00:00+00', 94);
INSERT INTO forum_post VALUES (50, 'morbi ut odio cras mi pede malesuada in', '2015-11-04 00:00:00+00', 'etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget semper', 20, '2017-03-23 00:00:00+00', 27);
INSERT INTO forum_post VALUES (51, 'mauris laoreet ut rhoncus aliquet pulvinar', '2015-08-28 00:00:00+01', 'eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero', 29, '2017-03-23 00:00:00+00', 69);
INSERT INTO forum_post VALUES (52, 'ultrices phasellus id sapien in sapien iaculis congue vivamus metus', '2015-09-21 00:00:00+01', 'tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum', 13, '2017-03-23 00:00:00+00', 75);
INSERT INTO forum_post VALUES (53, 'accumsan felis ut', '2015-09-11 00:00:00+01', 'vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla', 5, '2017-03-23 00:00:00+00', 30);
INSERT INTO forum_post VALUES (54, 'in', '2015-05-02 00:00:00+01', 'posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus', 19, '2017-03-23 00:00:00+00', 26);
INSERT INTO forum_post VALUES (55, 'cras pellentesque volutpat dui', '2016-09-15 00:00:00+01', 'vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin', 4, '2017-03-23 00:00:00+00', 43);
INSERT INTO forum_post VALUES (56, 'platea dictumst', '2015-09-07 00:00:00+01', 'pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio', 24, '2017-03-23 00:00:00+00', 74);
INSERT INTO forum_post VALUES (57, 'est quam pharetra', '2015-06-20 00:00:00+01', 'lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla integer pede', 30, '2017-03-23 00:00:00+00', 9);
INSERT INTO forum_post VALUES (58, 'lacus morbi quis tortor id nulla ultrices aliquet maecenas leo', '2016-02-29 00:00:00+00', 'habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec', 27, '2017-03-23 00:00:00+00', 85);
INSERT INTO forum_post VALUES (59, 'ut dolor morbi vel', '2015-10-11 00:00:00+01', 'vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis', 4, '2017-03-23 00:00:00+00', 60);
INSERT INTO forum_post VALUES (60, 'sapien urna pretium nisl ut', '2016-10-07 00:00:00+01', 'in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce', 8, '2017-03-23 00:00:00+00', 60);
INSERT INTO forum_post VALUES (61, 'sem duis aliquam convallis nunc proin at', '2015-12-20 00:00:00+00', 'molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim', 26, '2017-03-23 00:00:00+00', 35);
INSERT INTO forum_post VALUES (62, 'posuere', '2016-06-05 00:00:00+01', 'lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst', 23, '2017-03-23 00:00:00+00', 32);
INSERT INTO forum_post VALUES (63, 'aenean auctor gravida sem praesent', '2016-06-27 00:00:00+01', 'mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas', 21, '2017-03-23 00:00:00+00', 29);
INSERT INTO forum_post VALUES (64, 'nibh fusce lacus purus aliquet at feugiat', '2016-05-14 00:00:00+01', 'suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci', 4, '2017-03-23 00:00:00+00', 34);
INSERT INTO forum_post VALUES (65, 'commodo vulputate justo in blandit', '2016-08-21 00:00:00+01', 'mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in', 1, '2017-03-23 00:00:00+00', 63);
INSERT INTO forum_post VALUES (66, 'tristique est et', '2015-07-23 00:00:00+01', 'cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula', 5, '2017-03-23 00:00:00+00', 52);
INSERT INTO forum_post VALUES (67, 'potenti nullam porttitor lacus at turpis donec posuere metus', '2015-09-06 00:00:00+01', 'diam vitae quam suspendisse potenti nullam porttitor lacus at turpis', 14, '2017-03-23 00:00:00+00', 52);
INSERT INTO forum_post VALUES (68, 'blandit nam nulla integer pede justo lacinia eget', '2015-06-20 00:00:00+01', 'diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum', 22, '2017-03-23 00:00:00+00', 91);
INSERT INTO forum_post VALUES (69, 'turpis adipiscing lorem vitae mattis', '2016-12-13 00:00:00+00', 'accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum', 13, '2017-03-23 00:00:00+00', 4);
INSERT INTO forum_post VALUES (70, 'condimentum curabitur in libero ut massa volutpat convallis morbi odio', '2016-10-07 00:00:00+01', 'ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum', 26, '2017-03-23 00:00:00+00', 35);
INSERT INTO forum_post VALUES (71, 'viverra eget congue eget semper rutrum', '2016-10-24 00:00:00+01', 'condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis', 8, '2017-03-23 00:00:00+00', 46);
INSERT INTO forum_post VALUES (72, 'amet turpis elementum', '2015-04-04 00:00:00+01', 'dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis', 28, '2017-03-23 00:00:00+00', 64);
INSERT INTO forum_post VALUES (73, 'bibendum imperdiet', '2015-04-26 00:00:00+01', 'maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio condimentum', 18, '2017-03-23 00:00:00+00', 47);
INSERT INTO forum_post VALUES (74, 'lacus', '2016-05-19 00:00:00+01', 'mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis', 28, '2017-03-23 00:00:00+00', 57);
INSERT INTO forum_post VALUES (75, 'eu', '2016-12-29 00:00:00+00', 'maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere nonummy integer non velit donec', 1, '2017-03-23 00:00:00+00', 12);
INSERT INTO forum_post VALUES (76, 'ipsum dolor sit amet consectetuer adipiscing elit proin risus', '2016-01-15 00:00:00+00', 'integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce', 30, '2017-03-23 00:00:00+00', 10);
INSERT INTO forum_post VALUES (77, 'aliquam lacus morbi quis tortor id nulla ultrices', '2016-01-14 00:00:00+00', 'dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor', 30, '2017-03-23 00:00:00+00', 67);
INSERT INTO forum_post VALUES (78, 'vulputate vitae nisl', '2015-07-06 00:00:00+01', 'tempus semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi', 1, '2017-03-23 00:00:00+00', 48);
INSERT INTO forum_post VALUES (79, 'aenean sit amet justo morbi ut odio cras mi', '2015-10-02 00:00:00+01', 'at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec', 5, '2017-03-23 00:00:00+00', 70);
INSERT INTO forum_post VALUES (80, 'nisi at nibh in', '2015-11-08 00:00:00+00', 'elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer ac', 16, '2017-03-23 00:00:00+00', 18);
INSERT INTO forum_post VALUES (81, 'diam', '2015-07-22 00:00:00+01', 'in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit', 6, '2017-03-23 00:00:00+00', 87);
INSERT INTO forum_post VALUES (83, 'mi nulla ac enim in tempor turpis', '2015-10-20 00:00:00+01', 'odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam', 16, '2017-03-23 00:00:00+00', 77);
INSERT INTO forum_post VALUES (84, 'vivamus tortor duis mattis egestas metus aenean fermentum donec', '2016-01-06 00:00:00+00', 'nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio', 14, '2017-03-23 00:00:00+00', 2);
INSERT INTO forum_post VALUES (85, 'turpis', '2016-08-18 00:00:00+01', 'vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget', 5, '2017-03-23 00:00:00+00', 95);
INSERT INTO forum_post VALUES (86, 'duis aliquam convallis nunc proin at turpis', '2016-01-02 00:00:00+00', 'cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae', 29, '2017-03-23 00:00:00+00', 24);
INSERT INTO forum_post VALUES (87, 'molestie', '2016-10-15 00:00:00+01', 'tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec', 12, '2017-03-23 00:00:00+00', 42);
INSERT INTO forum_post VALUES (88, 'a suscipit', '2015-05-31 00:00:00+01', 'dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus', 20, '2017-03-23 00:00:00+00', 31);
INSERT INTO forum_post VALUES (89, 'sed justo', '2016-01-10 00:00:00+00', 'ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi', 28, '2017-03-23 00:00:00+00', 3);
INSERT INTO forum_post VALUES (90, 'erat nulla tempus', '2015-04-25 00:00:00+01', 'id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor vel est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien', 23, '2017-03-23 00:00:00+00', 92);
INSERT INTO forum_post VALUES (91, 'quam nec dui luctus rutrum nulla tellus in', '2016-12-10 00:00:00+00', 'tortor risus dapibus augue vel accumsan tellus nisi eu orci', 7, '2017-03-23 00:00:00+00', 71);
INSERT INTO forum_post VALUES (92, 'faucibus orci luctus et ultrices posuere cubilia', '2016-12-05 00:00:00+00', 'pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida', 16, '2017-03-23 00:00:00+00', 100);
INSERT INTO forum_post VALUES (93, 'amet', '2015-09-06 00:00:00+01', 'morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse', 16, '2017-03-23 00:00:00+00', 8);
INSERT INTO forum_post VALUES (94, 'nisl nunc rhoncus', '2016-11-26 00:00:00+00', 'ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non', 3, '2017-03-23 00:00:00+00', 29);
INSERT INTO forum_post VALUES (95, 'eget congue eget semper rutrum nulla nunc purus phasellus in', '2015-09-02 00:00:00+01', 'interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis', 4, '2017-03-23 00:00:00+00', 51);
INSERT INTO forum_post VALUES (96, 'suspendisse potenti cras in purus eu magna vulputate luctus cum', '2016-12-26 00:00:00+00', 'nulla ultrices aliquet maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante', 29, '2017-03-23 00:00:00+00', 53);
INSERT INTO forum_post VALUES (97, 'nulla ultrices aliquet maecenas leo odio condimentum', '2015-12-23 00:00:00+00', 'aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus', 4, '2017-03-23 00:00:00+00', 76);
INSERT INTO forum_post VALUES (98, 'duis consequat dui', '2015-12-15 00:00:00+00', 'ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac', 22, '2017-03-23 00:00:00+00', 32);
INSERT INTO forum_post VALUES (99, 'semper rutrum nulla nunc purus phasellus in felis donec semper', '2015-03-23 00:00:00+00', 'nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula', 22, '2017-03-23 00:00:00+00', 93);
INSERT INTO forum_post VALUES (100, 'leo pellentesque ultrices mattis odio donec vitae nisi nam', '2016-09-05 00:00:00+01', 'nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat', 10, '2017-03-23 00:00:00+00', 70);
INSERT INTO forum_post VALUES (1, 'ut at dolor quis odio', '2015-03-10 00:00:00+00', 'montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo in', 19, '2017-03-25 17:41:09.165391+00', 23);


--
-- Name: forum_post_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1614
--

SELECT pg_catalog.setval('forum_post_id_seq', 9, true);


--
-- Data for Name: forum_post_like; Type: TABLE DATA; Schema: public; Owner: lbaw1614
--

INSERT INTO forum_post_like VALUES (45, 28);
INSERT INTO forum_post_like VALUES (45, 60);
INSERT INTO forum_post_like VALUES (16, 31);
INSERT INTO forum_post_like VALUES (81, 35);
INSERT INTO forum_post_like VALUES (98, 49);
INSERT INTO forum_post_like VALUES (95, 59);
INSERT INTO forum_post_like VALUES (29, 24);
INSERT INTO forum_post_like VALUES (87, 76);
INSERT INTO forum_post_like VALUES (84, 68);
INSERT INTO forum_post_like VALUES (79, 82);
INSERT INTO forum_post_like VALUES (62, 23);
INSERT INTO forum_post_like VALUES (54, 23);
INSERT INTO forum_post_like VALUES (63, 26);
INSERT INTO forum_post_like VALUES (18, 80);
INSERT INTO forum_post_like VALUES (85, 91);
INSERT INTO forum_post_like VALUES (91, 53);
INSERT INTO forum_post_like VALUES (100, 99);
INSERT INTO forum_post_like VALUES (41, 99);
INSERT INTO forum_post_like VALUES (47, 88);
INSERT INTO forum_post_like VALUES (39, 30);
INSERT INTO forum_post_like VALUES (27, 71);
INSERT INTO forum_post_like VALUES (26, 71);
INSERT INTO forum_post_like VALUES (61, 33);
INSERT INTO forum_post_like VALUES (22, 5);
INSERT INTO forum_post_like VALUES (69, 19);
INSERT INTO forum_post_like VALUES (94, 48);
INSERT INTO forum_post_like VALUES (43, 96);
INSERT INTO forum_post_like VALUES (93, 16);
INSERT INTO forum_post_like VALUES (43, 6);
INSERT INTO forum_post_like VALUES (32, 16);
INSERT INTO forum_post_like VALUES (79, 21);
INSERT INTO forum_post_like VALUES (26, 67);
INSERT INTO forum_post_like VALUES (66, 22);
INSERT INTO forum_post_like VALUES (80, 80);
INSERT INTO forum_post_like VALUES (74, 20);
INSERT INTO forum_post_like VALUES (29, 4);
INSERT INTO forum_post_like VALUES (80, 59);
INSERT INTO forum_post_like VALUES (76, 58);
INSERT INTO forum_post_like VALUES (5, 89);
INSERT INTO forum_post_like VALUES (23, 76);
INSERT INTO forum_post_like VALUES (24, 62);
INSERT INTO forum_post_like VALUES (24, 43);
INSERT INTO forum_post_like VALUES (41, 42);
INSERT INTO forum_post_like VALUES (41, 2);
INSERT INTO forum_post_like VALUES (43, 15);
INSERT INTO forum_post_like VALUES (64, 61);
INSERT INTO forum_post_like VALUES (41, 100);
INSERT INTO forum_post_like VALUES (82, 96);
INSERT INTO forum_post_like VALUES (10, 31);
INSERT INTO forum_post_like VALUES (7, 76);
INSERT INTO forum_post_like VALUES (11, 31);
INSERT INTO forum_post_like VALUES (35, 71);
INSERT INTO forum_post_like VALUES (22, 7);
INSERT INTO forum_post_like VALUES (66, 98);
INSERT INTO forum_post_like VALUES (18, 26);
INSERT INTO forum_post_like VALUES (29, 33);
INSERT INTO forum_post_like VALUES (41, 6);
INSERT INTO forum_post_like VALUES (95, 90);
INSERT INTO forum_post_like VALUES (13, 25);
INSERT INTO forum_post_like VALUES (12, 57);
INSERT INTO forum_post_like VALUES (60, 58);
INSERT INTO forum_post_like VALUES (87, 45);
INSERT INTO forum_post_like VALUES (61, 9);
INSERT INTO forum_post_like VALUES (86, 69);
INSERT INTO forum_post_like VALUES (91, 7);
INSERT INTO forum_post_like VALUES (53, 30);
INSERT INTO forum_post_like VALUES (3, 97);
INSERT INTO forum_post_like VALUES (11, 5);
INSERT INTO forum_post_like VALUES (82, 28);
INSERT INTO forum_post_like VALUES (41, 9);
INSERT INTO forum_post_like VALUES (63, 97);
INSERT INTO forum_post_like VALUES (63, 18);
INSERT INTO forum_post_like VALUES (11, 75);
INSERT INTO forum_post_like VALUES (67, 78);
INSERT INTO forum_post_like VALUES (37, 12);
INSERT INTO forum_post_like VALUES (89, 23);
INSERT INTO forum_post_like VALUES (95, 27);
INSERT INTO forum_post_like VALUES (8, 35);
INSERT INTO forum_post_like VALUES (84, 87);
INSERT INTO forum_post_like VALUES (25, 82);
INSERT INTO forum_post_like VALUES (89, 26);
INSERT INTO forum_post_like VALUES (16, 15);
INSERT INTO forum_post_like VALUES (1, 82);
INSERT INTO forum_post_like VALUES (55, 5);
INSERT INTO forum_post_like VALUES (33, 88);
INSERT INTO forum_post_like VALUES (4, 90);
INSERT INTO forum_post_like VALUES (56, 36);
INSERT INTO forum_post_like VALUES (20, 45);
INSERT INTO forum_post_like VALUES (78, 41);
INSERT INTO forum_post_like VALUES (2, 16);
INSERT INTO forum_post_like VALUES (13, 59);
INSERT INTO forum_post_like VALUES (69, 68);
INSERT INTO forum_post_like VALUES (86, 81);
INSERT INTO forum_post_like VALUES (92, 42);
INSERT INTO forum_post_like VALUES (46, 18);
INSERT INTO forum_post_like VALUES (75, 25);
INSERT INTO forum_post_like VALUES (78, 81);
INSERT INTO forum_post_like VALUES (84, 56);
INSERT INTO forum_post_like VALUES (40, 41);
INSERT INTO forum_post_like VALUES (58, 54);


--
-- Data for Name: forum_reply; Type: TABLE DATA; Schema: public; Owner: lbaw1614
--

INSERT INTO forum_reply VALUES (39, '2017-03-16 00:00:00+00', 'Flail joint, left knee', 36, 2);
INSERT INTO forum_reply VALUES (47, '2015-11-17 00:00:00+00', 'Other kyphosis, cervical region', 26, 88);
INSERT INTO forum_reply VALUES (35, '2017-02-10 00:00:00+00', 'Nondisplaced fracture of distal phalanx of unspecified great toe, subsequent encounter for fracture with delayed healing', 35, 84);
INSERT INTO forum_reply VALUES (87, '2016-12-26 00:00:00+00', 'Fracture of coronoid process of left mandible, initial encounter for open fracture', 46, 34);
INSERT INTO forum_reply VALUES (48, '2015-04-20 00:00:00+01', 'Puncture wound without foreign body of unspecified front wall of thorax with penetration into thoracic cavity, initial encounter', 17, 29);
INSERT INTO forum_reply VALUES (54, '2015-05-09 00:00:00+01', 'Laceration with foreign body of right little finger with damage to nail', 67, 25);
INSERT INTO forum_reply VALUES (32, '2017-01-11 00:00:00+00', 'Diffuse interstitial keratitis, bilateral', 1, 39);
INSERT INTO forum_reply VALUES (19, '2017-02-14 00:00:00+00', 'Other disturbances of skin sensation', 35, 50);
INSERT INTO forum_reply VALUES (51, '2016-10-16 00:00:00+01', 'Salter-Harris Type III physeal fracture of phalanx of left toe', 88, 6);
INSERT INTO forum_reply VALUES (68, '2015-11-12 00:00:00+00', 'Underdosing of androgens and anabolic congeners, initial encounter', 37, 78);
INSERT INTO forum_reply VALUES (94, '2015-10-04 00:00:00+01', 'Other fracture of upper end of left ulna, subsequent encounter for open fracture type I or II with nonunion', 47, 12);
INSERT INTO forum_reply VALUES (74, '2016-06-28 00:00:00+01', 'Juvenile osteochondrosis of spine', 41, 82);
INSERT INTO forum_reply VALUES (72, '2016-04-30 00:00:00+01', 'Ocular laceration and rupture with prolapse or loss of intraocular tissue, unspecified eye, initial encounter', 68, 40);
INSERT INTO forum_reply VALUES (29, '2016-02-17 00:00:00+00', 'Anterior cord syndrome at C7 level of cervical spinal cord, sequela', 32, 92);
INSERT INTO forum_reply VALUES (55, '2016-10-06 00:00:00+01', 'Unspecified open wound of left middle finger without damage to nail', 45, 53);
INSERT INTO forum_reply VALUES (56, '2015-11-09 00:00:00+00', 'Keratoderma in diseases classified elsewhere', 40, 70);
INSERT INTO forum_reply VALUES (44, '2017-02-12 00:00:00+00', 'Nondisplaced fracture of medial phalanx of left lesser toe(s), subsequent encounter for fracture with delayed healing', 64, 50);
INSERT INTO forum_reply VALUES (14, '2016-10-05 00:00:00+01', 'Fracture of unspecified carpal bone, right wrist, sequela', 36, 13);
INSERT INTO forum_reply VALUES (70, '2016-08-17 00:00:00+01', 'Multiple fractures of pelvis with unstable disruption of pelvic ring, initial encounter for open fracture', 74, 79);
INSERT INTO forum_reply VALUES (61, '2017-02-17 00:00:00+00', 'Unspecified intracranial injury with loss of consciousness of 30 minutes or less, initial encounter', 94, 61);
INSERT INTO forum_reply VALUES (71, '2015-10-10 00:00:00+01', 'Toxic effect of other seafood, assault, subsequent encounter', 33, 23);
INSERT INTO forum_reply VALUES (43, '2017-03-11 00:00:00+00', 'Bilateral primary osteoarthritis of knee', 60, 75);
INSERT INTO forum_reply VALUES (12, '2016-07-16 00:00:00+01', 'Unspecified fall due to ice and snow', 63, 92);
INSERT INTO forum_reply VALUES (79, '2016-10-06 00:00:00+01', 'Hydrocele and spermatocele', 42, 9);
INSERT INTO forum_reply VALUES (46, '2015-08-30 00:00:00+01', 'Injury of femoral nerve at hip and thigh level, right leg, sequela', 1, 23);
INSERT INTO forum_reply VALUES (7, '2015-05-24 00:00:00+01', 'Corrosion of second degree of male genital region, subsequent encounter', 9, 49);
INSERT INTO forum_reply VALUES (89, '2016-10-17 00:00:00+01', 'Unspecified effects of drowning and nonfatal submersion, sequela', 60, 22);
INSERT INTO forum_reply VALUES (8, '2016-09-30 00:00:00+01', 'Poisoning by emetics, undetermined', 60, 1);
INSERT INTO forum_reply VALUES (82, '2016-10-13 00:00:00+01', 'Pathological dislocation of unspecified ankle, not elsewhere classified', 73, 24);
INSERT INTO forum_reply VALUES (53, '2015-12-03 00:00:00+00', 'Superficial frostbite of unspecified foot, subsequent encounter', 2, 61);
INSERT INTO forum_reply VALUES (84, '2016-10-12 00:00:00+01', 'Animal-rider injured in collision with animal-drawn vehicle, sequela', 23, 50);
INSERT INTO forum_reply VALUES (76, '2016-12-24 00:00:00+00', 'Salter-Harris Type III physeal fracture of upper end of radius, unspecified arm, subsequent encounter for fracture with nonunion', 55, 74);
INSERT INTO forum_reply VALUES (81, '2015-12-05 00:00:00+00', 'Displaced fracture of base of other metacarpal bone, initial encounter for open fracture', 62, 22);
INSERT INTO forum_reply VALUES (15, '2016-01-30 00:00:00+00', 'Arthropathy following intestinal bypass, right wrist', 29, 25);
INSERT INTO forum_reply VALUES (95, '2016-04-01 00:00:00+01', 'Gastric contents in other parts of respiratory tract causing asphyxiation, initial encounter', 50, 35);
INSERT INTO forum_reply VALUES (26, '2016-04-25 00:00:00+01', 'Burn of third degree of female genital region', 47, 15);
INSERT INTO forum_reply VALUES (5, '2017-01-31 00:00:00+00', 'Nondisplaced comminuted fracture of shaft of ulna, right arm, subsequent encounter for open fracture type IIIA, IIIB, or IIIC with nonunion', 4, 10);
INSERT INTO forum_reply VALUES (58, '2015-06-25 00:00:00+01', 'Complete lesion of L3 level of lumbar spinal cord, initial encounter', 65, 71);
INSERT INTO forum_reply VALUES (88, '2016-07-25 00:00:00+01', 'Pain in hip', 30, 89);
INSERT INTO forum_reply VALUES (33, '2015-07-20 00:00:00+01', 'Nondisplaced fracture of medial phalanx of left ring finger, subsequent encounter for fracture with routine healing', 82, 9);
INSERT INTO forum_reply VALUES (90, '2015-11-06 00:00:00+00', 'Corrosion of right eyelid and periocular area, subsequent encounter', 77, 83);
INSERT INTO forum_reply VALUES (10, '2015-08-05 00:00:00+01', 'Corrosion of unspecified degree of lip(s), subsequent encounter', 62, 48);
INSERT INTO forum_reply VALUES (83, '2015-11-13 00:00:00+00', 'Puncture wound without foreign body of unspecified toe(s) with damage to nail, initial encounter', 94, 45);
INSERT INTO forum_reply VALUES (18, '2015-07-19 00:00:00+01', 'Osteonecrosis due to previous trauma, unspecified foot', 30, 18);
INSERT INTO forum_reply VALUES (73, '2015-05-17 00:00:00+01', 'Laceration of adductor muscle, fascia and tendon of right thigh, initial encounter', 32, 24);
INSERT INTO forum_reply VALUES (91, '2016-10-10 00:00:00+01', 'Other specified injuries of right elbow, subsequent encounter', 66, 87);
INSERT INTO forum_reply VALUES (41, '2016-01-11 00:00:00+00', 'Explosion and rupture of other specified pressurized devices', 16, 35);
INSERT INTO forum_reply VALUES (97, '2015-09-01 00:00:00+01', 'Laceration with foreign body of other part of head', 85, 99);
INSERT INTO forum_reply VALUES (96, '2015-05-22 00:00:00+01', 'Pre-existing hypertensive chronic kidney disease complicating childbirth', 34, 17);
INSERT INTO forum_reply VALUES (30, '2017-02-23 00:00:00+00', 'Degeneration of pupillary margin, unspecified eye', 16, 97);
INSERT INTO forum_reply VALUES (57, '2015-08-09 00:00:00+01', 'Other specified disorders of bone density and structure, ankle and foot', 2, 88);
INSERT INTO forum_reply VALUES (28, '2017-01-16 00:00:00+00', 'Poisoning by loop [high-ceiling] diuretics, undetermined, subsequent encounter', 9, 6);
INSERT INTO forum_reply VALUES (50, '2016-02-10 00:00:00+00', 'Acute mastoiditis without complications', 38, 81);
INSERT INTO forum_reply VALUES (38, '2016-02-29 00:00:00+00', 'Corrosion of third degree of unspecified foot, subsequent encounter', 11, 58);
INSERT INTO forum_reply VALUES (25, '2016-07-29 00:00:00+01', 'Other peripheral vertigo, left ear', 97, 42);
INSERT INTO forum_reply VALUES (99, '2016-11-25 00:00:00+00', 'Unspecified motorcycle rider injured in collision with car, pick-up truck or van in nontraffic accident', 87, 38);
INSERT INTO forum_reply VALUES (21, '2016-07-05 00:00:00+01', 'Rheumatoid arthritis without rheumatoid factor, vertebrae', 75, 47);
INSERT INTO forum_reply VALUES (23, '2016-12-12 00:00:00+00', 'Corrosion of third degree of multiple sites of right ankle and foot, initial encounter', 60, 64);
INSERT INTO forum_reply VALUES (1, '2016-05-05 00:00:00+01', 'Major laceration of right innominate or subclavian artery, initial encounter', 85, 98);
INSERT INTO forum_reply VALUES (66, '2016-10-26 00:00:00+01', 'Other fracture of shaft of left ulna, initial encounter for open fracture type IIIA, IIIB, or IIIC', 77, 100);
INSERT INTO forum_reply VALUES (27, '2015-09-22 00:00:00+01', 'Other specified injury of unspecified blood vessel at hip and thigh level, left leg', 55, 88);
INSERT INTO forum_reply VALUES (502, '2017-03-23 00:00:00+00', 'Teste 3', 2, 1);


--
-- Name: forum_reply_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1614
--

SELECT pg_catalog.setval('forum_reply_id_seq', 6, true);


--
-- Data for Name: forum_reply_like; Type: TABLE DATA; Schema: public; Owner: lbaw1614
--

INSERT INTO forum_reply_like VALUES (34, 77);
INSERT INTO forum_reply_like VALUES (47, 79);
INSERT INTO forum_reply_like VALUES (45, 1);
INSERT INTO forum_reply_like VALUES (19, 40);
INSERT INTO forum_reply_like VALUES (27, 13);
INSERT INTO forum_reply_like VALUES (27, 14);
INSERT INTO forum_reply_like VALUES (41, 56);
INSERT INTO forum_reply_like VALUES (20, 91);
INSERT INTO forum_reply_like VALUES (3, 34);
INSERT INTO forum_reply_like VALUES (59, 45);
INSERT INTO forum_reply_like VALUES (14, 37);
INSERT INTO forum_reply_like VALUES (56, 22);
INSERT INTO forum_reply_like VALUES (57, 90);
INSERT INTO forum_reply_like VALUES (29, 48);
INSERT INTO forum_reply_like VALUES (52, 7);
INSERT INTO forum_reply_like VALUES (13, 38);
INSERT INTO forum_reply_like VALUES (2, 86);
INSERT INTO forum_reply_like VALUES (18, 55);
INSERT INTO forum_reply_like VALUES (3, 58);
INSERT INTO forum_reply_like VALUES (19, 72);
INSERT INTO forum_reply_like VALUES (44, 46);
INSERT INTO forum_reply_like VALUES (58, 85);
INSERT INTO forum_reply_like VALUES (19, 7);
INSERT INTO forum_reply_like VALUES (54, 80);
INSERT INTO forum_reply_like VALUES (54, 50);
INSERT INTO forum_reply_like VALUES (43, 34);
INSERT INTO forum_reply_like VALUES (14, 70);
INSERT INTO forum_reply_like VALUES (43, 50);
INSERT INTO forum_reply_like VALUES (34, 75);
INSERT INTO forum_reply_like VALUES (53, 72);
INSERT INTO forum_reply_like VALUES (39, 60);
INSERT INTO forum_reply_like VALUES (2, 74);
INSERT INTO forum_reply_like VALUES (16, 59);
INSERT INTO forum_reply_like VALUES (40, 17);
INSERT INTO forum_reply_like VALUES (21, 18);
INSERT INTO forum_reply_like VALUES (18, 21);
INSERT INTO forum_reply_like VALUES (44, 64);
INSERT INTO forum_reply_like VALUES (40, 96);
INSERT INTO forum_reply_like VALUES (60, 34);
INSERT INTO forum_reply_like VALUES (29, 68);
INSERT INTO forum_reply_like VALUES (36, 52);
INSERT INTO forum_reply_like VALUES (16, 69);
INSERT INTO forum_reply_like VALUES (49, 82);
INSERT INTO forum_reply_like VALUES (49, 29);
INSERT INTO forum_reply_like VALUES (27, 40);
INSERT INTO forum_reply_like VALUES (29, 61);
INSERT INTO forum_reply_like VALUES (3, 46);
INSERT INTO forum_reply_like VALUES (19, 72);
INSERT INTO forum_reply_like VALUES (35, 72);
INSERT INTO forum_reply_like VALUES (1, 75);
INSERT INTO forum_reply_like VALUES (6, 21);
INSERT INTO forum_reply_like VALUES (12, 72);
INSERT INTO forum_reply_like VALUES (44, 2);
INSERT INTO forum_reply_like VALUES (56, 30);
INSERT INTO forum_reply_like VALUES (40, 51);
INSERT INTO forum_reply_like VALUES (42, 31);
INSERT INTO forum_reply_like VALUES (12, 16);
INSERT INTO forum_reply_like VALUES (34, 90);
INSERT INTO forum_reply_like VALUES (29, 62);
INSERT INTO forum_reply_like VALUES (48, 18);
INSERT INTO forum_reply_like VALUES (56, 12);
INSERT INTO forum_reply_like VALUES (27, 11);
INSERT INTO forum_reply_like VALUES (54, 96);
INSERT INTO forum_reply_like VALUES (50, 96);
INSERT INTO forum_reply_like VALUES (53, 20);
INSERT INTO forum_reply_like VALUES (59, 56);
INSERT INTO forum_reply_like VALUES (50, 46);
INSERT INTO forum_reply_like VALUES (22, 83);
INSERT INTO forum_reply_like VALUES (45, 5);
INSERT INTO forum_reply_like VALUES (35, 86);
INSERT INTO forum_reply_like VALUES (55, 56);
INSERT INTO forum_reply_like VALUES (13, 70);
INSERT INTO forum_reply_like VALUES (47, 72);
INSERT INTO forum_reply_like VALUES (13, 94);
INSERT INTO forum_reply_like VALUES (27, 75);
INSERT INTO forum_reply_like VALUES (3, 80);
INSERT INTO forum_reply_like VALUES (30, 69);
INSERT INTO forum_reply_like VALUES (32, 59);
INSERT INTO forum_reply_like VALUES (4, 31);
INSERT INTO forum_reply_like VALUES (10, 49);
INSERT INTO forum_reply_like VALUES (10, 49);
INSERT INTO forum_reply_like VALUES (59, 29);
INSERT INTO forum_reply_like VALUES (39, 8);
INSERT INTO forum_reply_like VALUES (7, 33);
INSERT INTO forum_reply_like VALUES (31, 82);
INSERT INTO forum_reply_like VALUES (55, 65);
INSERT INTO forum_reply_like VALUES (38, 68);
INSERT INTO forum_reply_like VALUES (25, 7);
INSERT INTO forum_reply_like VALUES (3, 63);
INSERT INTO forum_reply_like VALUES (33, 28);
INSERT INTO forum_reply_like VALUES (46, 29);
INSERT INTO forum_reply_like VALUES (10, 41);
INSERT INTO forum_reply_like VALUES (39, 53);
INSERT INTO forum_reply_like VALUES (2, 21);
INSERT INTO forum_reply_like VALUES (33, 54);
INSERT INTO forum_reply_like VALUES (52, 38);
INSERT INTO forum_reply_like VALUES (12, 67);
INSERT INTO forum_reply_like VALUES (35, 93);
INSERT INTO forum_reply_like VALUES (9, 90);
INSERT INTO forum_reply_like VALUES (13, 100);


--
-- Data for Name: meeting; Type: TABLE DATA; Schema: public; Owner: lbaw1614
--

INSERT INTO meeting VALUES (1, 'reinvent next-generation web-readiness', '2016-12-22 00:00:00+00', 180, 'Decentralized impactful time-frame', 26, 4);
INSERT INTO meeting VALUES (2, 'evolve one-to-one platforms', '2018-02-01 00:00:00+00', 182, 'Polarised mobile software', 25, 13);
INSERT INTO meeting VALUES (3, 'strategize e-business users', '2016-06-16 00:00:00+01', 218, 'Realigned contextually-based strategy', 15, 14);
INSERT INTO meeting VALUES (4, 'aggregate frictionless ROI', '2017-07-09 00:00:00+01', 38, 'Re-engineered holistic capability', 11, 9);
INSERT INTO meeting VALUES (5, 'utilize killer methodologies', '2016-10-29 00:00:00+01', 51, 'Re-engineered holistic toolset', 4, 9);
INSERT INTO meeting VALUES (6, 'monetize e-business users', '2017-05-18 00:00:00+01', 74, 'Object-based transitional Graphical User Interface', 8, 22);
INSERT INTO meeting VALUES (7, 'synthesize plug-and-play communities', '2016-09-07 00:00:00+01', 104, 'Polarised needs-based synergy', 30, 23);
INSERT INTO meeting VALUES (8, 'brand enterprise action-items', '2017-02-18 00:00:00+00', 31, 'Advanced methodical flexibility', 19, 19);
INSERT INTO meeting VALUES (9, 'transform rich portals', '2016-07-02 00:00:00+01', 109, 'Fully-configurable bottom-line moderator', 10, 11);
INSERT INTO meeting VALUES (10, 'scale B2C relationships', '2016-03-29 00:00:00+01', 87, 'Streamlined object-oriented focus group', 9, 30);
INSERT INTO meeting VALUES (11, 'target seamless portals', '2018-01-02 00:00:00+00', 226, 'Switchable modular implementation', 11, 7);
INSERT INTO meeting VALUES (12, 'exploit ubiquitous infomediaries', '2017-06-30 00:00:00+01', 20, 'Automated composite utilisation', 11, 16);
INSERT INTO meeting VALUES (13, 'cultivate B2C schemas', '2017-03-26 00:00:00+00', 68, 'Reduced national throughput', 22, 5);
INSERT INTO meeting VALUES (14, 'revolutionize transparent e-commerce', '2017-07-08 00:00:00+01', 111, 'Business-focused multi-tasking leverage', 18, 14);
INSERT INTO meeting VALUES (15, 'architect next-generation convergence', '2017-11-07 00:00:00+00', 113, 'Object-based intermediate core', 24, 23);
INSERT INTO meeting VALUES (16, 'cultivate plug-and-play e-commerce', '2016-11-12 00:00:00+00', 220, 'Future-proofed empowering hardware', 22, 21);
INSERT INTO meeting VALUES (17, 'whiteboard front-end web-readiness', '2016-09-15 00:00:00+01', 41, 'Distributed non-volatile local area network', 28, 29);
INSERT INTO meeting VALUES (18, 'deliver 24/7 metrics', '2016-10-21 00:00:00+01', 167, 'Synergized even-keeled alliance', 22, 14);
INSERT INTO meeting VALUES (19, 'integrate clicks-and-mortar relationships', '2017-11-13 00:00:00+00', 217, 'Object-based systemic moderator', 27, 7);
INSERT INTO meeting VALUES (20, 'iterate web-enabled niches', '2018-03-19 00:00:00+00', 46, 'Persevering didactic database', 17, 26);
INSERT INTO meeting VALUES (21, 'target world-class infomediaries', '2017-02-02 00:00:00+00', 62, 'Stand-alone client-driven installation', 4, 15);
INSERT INTO meeting VALUES (22, 'recontextualize web-enabled convergence', '2018-02-06 00:00:00+00', 170, 'Reduced national neural-net', 14, 26);
INSERT INTO meeting VALUES (23, 'redefine extensible technologies', '2017-12-02 00:00:00+00', 76, 'Switchable encompassing throughput', 20, 30);
INSERT INTO meeting VALUES (24, 'seize virtual channels', '2017-01-17 00:00:00+00', 53, 'Compatible user-facing knowledge base', 11, 9);
INSERT INTO meeting VALUES (25, 'aggregate scalable e-services', '2016-10-09 00:00:00+01', 72, 'Customizable non-volatile infrastructure', 21, 1);
INSERT INTO meeting VALUES (26, 'strategize magnetic partnerships', '2018-03-01 00:00:00+00', 231, 'Face to face content-based system engine', 27, 24);
INSERT INTO meeting VALUES (27, 'revolutionize value-added communities', '2016-12-30 00:00:00+00', 67, 'User-friendly optimal focus group', 27, 29);
INSERT INTO meeting VALUES (28, 'innovate viral web services', '2016-09-19 00:00:00+01', 210, 'Triple-buffered analyzing encryption', 22, 17);
INSERT INTO meeting VALUES (29, 'brand real-time interfaces', '2017-04-09 00:00:00+01', 15, 'Multi-channelled value-added throughput', 27, 7);
INSERT INTO meeting VALUES (30, 'extend dynamic initiatives', '2016-08-20 00:00:00+01', 22, 'Seamless bi-directional strategy', 27, 29);
INSERT INTO meeting VALUES (31, 'reinvent holistic architectures', '2017-04-03 00:00:00+01', 237, 'Synergized object-oriented monitoring', 11, 6);
INSERT INTO meeting VALUES (32, 'visualize B2C schemas', '2017-10-13 00:00:00+01', 214, 'Versatile bifurcated matrix', 7, 27);
INSERT INTO meeting VALUES (33, 'syndicate integrated e-business', '2018-01-03 00:00:00+00', 213, 'Profit-focused discrete algorithm', 12, 15);
INSERT INTO meeting VALUES (34, 'grow compelling paradigms', '2016-09-25 00:00:00+01', 171, 'Versatile empowering superstructure', 9, 19);
INSERT INTO meeting VALUES (35, 'engage best-of-breed infomediaries', '2016-07-28 00:00:00+01', 33, 'Versatile explicit focus group', 6, 23);
INSERT INTO meeting VALUES (36, 'facilitate best-of-breed methodologies', '2017-05-01 00:00:00+01', 188, 'Polarised solution-oriented pricing structure', 30, 11);
INSERT INTO meeting VALUES (37, 'optimize real-time models', '2017-04-08 00:00:00+01', 106, 'Configurable systemic service-desk', 8, 11);
INSERT INTO meeting VALUES (38, 'productize 24/365 infomediaries', '2017-11-26 00:00:00+00', 79, 'Decentralized logistical matrix', 23, 9);
INSERT INTO meeting VALUES (39, 'engineer 24/365 vortals', '2016-05-26 00:00:00+01', 201, 'Synergized fresh-thinking attitude', 9, 8);
INSERT INTO meeting VALUES (40, 'brand revolutionary eyeballs', '2016-06-08 00:00:00+01', 148, 'Right-sized incremental frame', 27, 23);
INSERT INTO meeting VALUES (41, 'aggregate leading-edge platforms', '2016-06-13 00:00:00+01', 65, 'Persevering explicit circuit', 7, 2);
INSERT INTO meeting VALUES (42, 'cultivate killer e-services', '2017-01-09 00:00:00+00', 188, 'Fundamental encompassing monitoring', 23, 17);
INSERT INTO meeting VALUES (43, 'evolve collaborative supply-chains', '2017-05-14 00:00:00+01', 226, 'Reverse-engineered contextually-based attitude', 7, 25);
INSERT INTO meeting VALUES (44, 'harness transparent paradigms', '2018-03-15 00:00:00+00', 24, 'Seamless responsive attitude', 20, 29);
INSERT INTO meeting VALUES (45, 'embrace world-class web services', '2016-09-10 00:00:00+01', 117, 'Visionary multimedia Graphic Interface', 12, 19);
INSERT INTO meeting VALUES (46, 'generate bricks-and-clicks deliverables', '2017-05-21 00:00:00+01', 133, 'Monitored modular customer loyalty', 5, 13);
INSERT INTO meeting VALUES (47, 'extend proactive infomediaries', '2017-02-24 00:00:00+00', 165, 'Innovative incremental array', 6, 6);
INSERT INTO meeting VALUES (48, 'whiteboard B2B functionalities', '2016-12-31 00:00:00+00', 80, 'Diverse 5th generation algorithm', 20, 8);
INSERT INTO meeting VALUES (49, 'iterate cutting-edge metrics', '2017-05-30 00:00:00+01', 197, 'Stand-alone homogeneous implementation', 6, 7);
INSERT INTO meeting VALUES (50, 'envisioneer viral experiences', '2017-02-16 00:00:00+00', 37, 'Persevering dedicated frame', 6, 27);
INSERT INTO meeting VALUES (51, 'integrate open-source users', '2018-02-03 00:00:00+00', 202, 'Object-based heuristic encoding', 15, 23);
INSERT INTO meeting VALUES (52, 'architect dot-com paradigms', '2018-01-06 00:00:00+00', 23, 'Robust system-worthy forecast', 22, 10);
INSERT INTO meeting VALUES (53, 'seize interactive content', '2017-02-11 00:00:00+00', 98, 'Visionary grid-enabled success', 3, 17);
INSERT INTO meeting VALUES (54, 'innovate impactful convergence', '2017-05-17 00:00:00+01', 188, 'Object-based hybrid hardware', 25, 4);
INSERT INTO meeting VALUES (55, 'expedite proactive infomediaries', '2017-04-29 00:00:00+01', 97, 'Devolved object-oriented contingency', 9, 23);
INSERT INTO meeting VALUES (56, 'mesh bleeding-edge bandwidth', '2016-09-22 00:00:00+01', 174, 'Intuitive logistical matrices', 27, 8);
INSERT INTO meeting VALUES (57, 'incentivize scalable eyeballs', '2018-02-26 00:00:00+00', 206, 'Decentralized object-oriented intranet', 14, 8);
INSERT INTO meeting VALUES (58, 'monetize frictionless infrastructures', '2016-06-05 00:00:00+01', 39, 'Automated content-based approach', 25, 1);
INSERT INTO meeting VALUES (59, 'exploit seamless web-readiness', '2018-02-14 00:00:00+00', 35, 'Upgradable content-based functionalities', 10, 26);
INSERT INTO meeting VALUES (60, 'optimize customized experiences', '2017-11-26 00:00:00+00', 124, 'Team-oriented even-keeled infrastructure', 14, 12);
INSERT INTO meeting VALUES (61, 'deploy interactive web services', '2017-12-03 00:00:00+00', 45, 'Phased systematic array', 2, 27);
INSERT INTO meeting VALUES (62, 'integrate granular portals', '2017-07-21 00:00:00+01', 103, 'Up-sized analyzing concept', 20, 17);
INSERT INTO meeting VALUES (63, 'matrix back-end infomediaries', '2016-08-29 00:00:00+01', 56, 'Horizontal logistical complexity', 1, 1);
INSERT INTO meeting VALUES (64, 'incubate viral e-markets', '2016-09-25 00:00:00+01', 80, 'Intuitive modular architecture', 22, 25);
INSERT INTO meeting VALUES (65, 'syndicate innovative systems', '2017-07-15 00:00:00+01', 228, 'Adaptive heuristic moratorium', 10, 29);
INSERT INTO meeting VALUES (66, 'facilitate frictionless deliverables', '2017-02-16 00:00:00+00', 72, 'Universal optimizing contingency', 14, 18);
INSERT INTO meeting VALUES (67, 'reintermediate transparent paradigms', '2016-12-08 00:00:00+00', 183, 'Team-oriented 24 hour archive', 4, 13);
INSERT INTO meeting VALUES (68, 'utilize innovative platforms', '2016-11-22 00:00:00+00', 168, 'Exclusive reciprocal secured line', 6, 6);
INSERT INTO meeting VALUES (69, 'expedite real-time vortals', '2016-04-19 00:00:00+01', 137, 'Right-sized multi-tasking hub', 2, 21);
INSERT INTO meeting VALUES (70, 'embrace value-added markets', '2018-01-06 00:00:00+00', 44, 'Integrated high-level standardization', 24, 19);
INSERT INTO meeting VALUES (71, 'integrate synergistic content', '2017-10-15 00:00:00+01', 15, 'Reduced heuristic protocol', 13, 25);
INSERT INTO meeting VALUES (72, 'recontextualize global solutions', '2018-01-03 00:00:00+00', 26, 'Virtual actuating archive', 27, 27);
INSERT INTO meeting VALUES (73, 'exploit proactive infrastructures', '2017-06-12 00:00:00+01', 232, 'Virtual well-modulated frame', 27, 29);
INSERT INTO meeting VALUES (74, 'revolutionize efficient ROI', '2016-10-18 00:00:00+01', 181, 'Up-sized 6th generation installation', 23, 28);
INSERT INTO meeting VALUES (75, 'scale proactive architectures', '2016-12-19 00:00:00+00', 227, 'Profound mobile open architecture', 7, 22);
INSERT INTO meeting VALUES (76, 'transform killer models', '2016-07-22 00:00:00+01', 208, 'Visionary bifurcated strategy', 19, 15);
INSERT INTO meeting VALUES (77, 'deploy cross-platform e-markets', '2017-01-23 00:00:00+00', 240, 'Multi-tiered eco-centric database', 5, 30);
INSERT INTO meeting VALUES (78, 'drive synergistic paradigms', '2017-04-08 00:00:00+01', 36, 'Exclusive local data-warehouse', 6, 3);
INSERT INTO meeting VALUES (79, 'productize front-end platforms', '2017-06-07 00:00:00+01', 83, 'Synergized static challenge', 6, 30);
INSERT INTO meeting VALUES (80, 'optimize best-of-breed eyeballs', '2017-07-16 00:00:00+01', 192, 'Self-enabling foreground approach', 9, 13);
INSERT INTO meeting VALUES (81, 'transition leading-edge systems', '2017-11-07 00:00:00+00', 140, 'Quality-focused value-added internet solution', 14, 8);
INSERT INTO meeting VALUES (82, 'productize front-end communities', '2016-03-31 00:00:00+01', 193, 'Decentralized bifurcated local area network', 28, 17);
INSERT INTO meeting VALUES (83, 'mesh user-centric synergies', '2016-05-17 00:00:00+01', 124, 'Ergonomic web-enabled analyzer', 13, 30);
INSERT INTO meeting VALUES (84, 'brand cutting-edge communities', '2018-03-09 00:00:00+00', 220, 'Universal next generation emulation', 13, 3);
INSERT INTO meeting VALUES (85, 'cultivate dot-com schemas', '2017-04-02 00:00:00+01', 158, 'Visionary 5th generation strategy', 22, 23);
INSERT INTO meeting VALUES (86, 'leverage leading-edge mindshare', '2016-08-30 00:00:00+01', 109, 'Versatile real-time matrix', 30, 22);
INSERT INTO meeting VALUES (87, 'e-enable sticky schemas', '2016-10-03 00:00:00+01', 78, 'Up-sized incremental monitoring', 5, 5);
INSERT INTO meeting VALUES (88, 'monetize extensible vortals', '2017-10-27 00:00:00+01', 111, 'User-friendly incremental definition', 19, 19);
INSERT INTO meeting VALUES (89, 'incentivize strategic channels', '2016-10-20 00:00:00+01', 15, 'Front-line multimedia task-force', 10, 7);
INSERT INTO meeting VALUES (90, 'matrix dynamic systems', '2017-12-08 00:00:00+00', 162, 'Virtual homogeneous help-desk', 1, 9);
INSERT INTO meeting VALUES (91, 'innovate real-time architectures', '2017-01-15 00:00:00+00', 34, 'Customizable secondary conglomeration', 20, 23);
INSERT INTO meeting VALUES (92, 'whiteboard cross-media bandwidth', '2016-06-13 00:00:00+01', 123, 'Function-based global flexibility', 18, 3);
INSERT INTO meeting VALUES (93, 'visualize frictionless models', '2017-08-07 00:00:00+01', 148, 'Team-oriented mission-critical ability', 11, 9);
INSERT INTO meeting VALUES (94, 'grow real-time ROI', '2017-07-17 00:00:00+01', 198, 'Open-architected methodical instruction set', 24, 4);
INSERT INTO meeting VALUES (95, 'productize scalable eyeballs', '2017-09-23 00:00:00+01', 138, 'Customer-focused foreground framework', 18, 1);
INSERT INTO meeting VALUES (96, 'mesh e-business functionalities', '2018-01-15 00:00:00+00', 182, 'De-engineered mobile strategy', 6, 11);
INSERT INTO meeting VALUES (97, 'reinvent open-source architectures', '2016-10-04 00:00:00+01', 129, 'Fundamental dynamic moderator', 15, 26);
INSERT INTO meeting VALUES (98, 'redefine web-enabled interfaces', '2017-12-23 00:00:00+00', 79, 'Multi-tiered real-time customer loyalty', 7, 9);
INSERT INTO meeting VALUES (99, 'recontextualize end-to-end infrastructures', '2016-11-06 00:00:00+00', 159, 'Adaptive optimizing open architecture', 19, 25);
INSERT INTO meeting VALUES (100, 'revolutionize granular e-services', '2017-09-16 00:00:00+01', 59, 'Right-sized foreground orchestration', 18, 17);
INSERT INTO meeting VALUES (103, 'TESTE', '2017-11-22 00:00:00+00', 78, 'Teste', 1, 1);


--
-- Data for Name: project; Type: TABLE DATA; Schema: public; Owner: lbaw1614
--

INSERT INTO project VALUES (1, 'Biodex', 'Dilation of Inferior Mesenteric Artery with Two Intraluminal Devices, Percutaneous Approach');
INSERT INTO project VALUES (2, 'Mat Lam Tam', 'Replacement of Right Humeral Shaft with Autologous Tissue Substitute, Percutaneous Approach');
INSERT INTO project VALUES (3, 'Stim', 'Release Left Lower Leg Subcutaneous Tissue and Fascia, Percutaneous Approach');
INSERT INTO project VALUES (4, 'Tresom', 'Dilation of Coronary Artery, One Artery, Bifurcation, with Three Drug-eluting Intraluminal Devices, Percutaneous Approach');
INSERT INTO project VALUES (5, 'Veribet', 'Inspection of Lumbar Vertebral Joint, External Approach');
INSERT INTO project VALUES (6, 'Zamit', 'Change Drainage Device in Right Upper Extremity, External Approach');
INSERT INTO project VALUES (7, 'Konklux', 'Drainage of Appendix with Drainage Device, Via Natural or Artificial Opening');
INSERT INTO project VALUES (8, 'Pannier', 'Occlusion of Left Internal Mammary Lymphatic with Intraluminal Device, Open Approach');
INSERT INTO project VALUES (9, 'Otcom', 'Beam Radiation of Ileum using Electrons');
INSERT INTO project VALUES (10, 'Zontrax', 'Fusion of Thoracic Vertebral Joint with Nonautologous Tissue Substitute, Posterior Approach, Posterior Column, Open Approach');
INSERT INTO project VALUES (11, 'Alpha', 'Dilation of Left Renal Artery, Bifurcation, with Three Drug-eluting Intraluminal Devices, Percutaneous Endoscopic Approach');
INSERT INTO project VALUES (12, 'Fixflex', 'Beam Radiation of Duodenum using Photons >10 MeV');
INSERT INTO project VALUES (13, 'Duobam', 'Division of Left Upper Arm Tendon, Percutaneous Endoscopic Approach');
INSERT INTO project VALUES (14, 'Subin', 'Insertion of Infusion Device into Right Metatarsal-Tarsal Joint, Percutaneous Approach');
INSERT INTO project VALUES (15, 'Cardguard', 'Plain Radiography of Right Eye');
INSERT INTO project VALUES (16, 'Home Ing', 'Replacement of Right Occipital Bone with Synthetic Substitute, Percutaneous Approach');
INSERT INTO project VALUES (17, 'Tempsoft', 'Imaging, Axial Skeleton, Except Skull and Facial Bones, Computerized Tomography (CT Scan)');
INSERT INTO project VALUES (18, 'Fintone', 'Excision of Left Humeral Head, Percutaneous Endoscopic Approach, Diagnostic');
INSERT INTO project VALUES (19, 'Opela', 'Revision of Drainage Device in Mediastinum, Open Approach');
INSERT INTO project VALUES (20, 'Job', 'Restriction of Left Main Bronchus with Intraluminal Device, Via Natural or Artificial Opening');
INSERT INTO project VALUES (21, 'Konklux', 'Removal of Spacer from Left Toe Phalangeal Joint, Open Approach');
INSERT INTO project VALUES (22, 'Biodex', 'Excision of Right Nipple, Percutaneous Approach, Diagnostic');
INSERT INTO project VALUES (23, 'Greenlam', 'Bypass Left Common Iliac Artery to Left Common Iliac Artery with Nonautologous Tissue Substitute, Open Approach');
INSERT INTO project VALUES (24, 'Fintone', 'Supplement Right Thorax Tendon with Nonautologous Tissue Substitute, Open Approach');
INSERT INTO project VALUES (25, 'Prodder', 'Removal of Synthetic Substitute from Right Shoulder Joint, Open Approach');
INSERT INTO project VALUES (26, 'Domainer', 'Restriction of Right Ureter with Extraluminal Device, Percutaneous Endoscopic Approach');
INSERT INTO project VALUES (27, 'Rank', 'Transfusion of Autologous Globulin into Peripheral Vein, Open Approach');
INSERT INTO project VALUES (28, 'Span', 'Excision of Right Rib, Open Approach');
INSERT INTO project VALUES (29, 'Ronstring', 'Revision of Infusion Device in Scrotum and Tunica Vaginalis, Open Approach');
INSERT INTO project VALUES (30, 'Alphazap', 'Replacement of Nasal Turbinate with Nonautologous Tissue Substitute, Via Natural or Artificial Opening');


--
-- Name: project_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1614
--

SELECT pg_catalog.setval('project_id_seq', 1, false);


--
-- Data for Name: tag; Type: TABLE DATA; Schema: public; Owner: lbaw1614
--

INSERT INTO tag VALUES (1, 'info-mediaries');
INSERT INTO tag VALUES (2, 'Persistent');
INSERT INTO tag VALUES (3, 'Self-enabling');
INSERT INTO tag VALUES (4, 'Reactive');
INSERT INTO tag VALUES (5, 'Reduced');
INSERT INTO tag VALUES (6, 'scalable');
INSERT INTO tag VALUES (7, 'toolset');
INSERT INTO tag VALUES (8, 'Inverse');
INSERT INTO tag VALUES (9, 'Sharable');
INSERT INTO tag VALUES (10, 'Balanced');
INSERT INTO tag VALUES (11, 'array');
INSERT INTO tag VALUES (12, 'Horizontal');
INSERT INTO tag VALUES (13, 'functionalities');
INSERT INTO tag VALUES (14, 'database');
INSERT INTO tag VALUES (15, 'Customizable');
INSERT INTO tag VALUES (16, 'eco-centric');
INSERT INTO tag VALUES (17, 'Enterprise-wide');
INSERT INTO tag VALUES (18, 'modular');
INSERT INTO tag VALUES (19, '3rd generation');
INSERT INTO tag VALUES (20, 'Integrated');


--
-- Name: tag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1614
--

SELECT pg_catalog.setval('tag_id_seq', 1, false);


--
-- Data for Name: task; Type: TABLE DATA; Schema: public; Owner: lbaw1614
--

INSERT INTO task VALUES (1, 'id', 'Exposure to smoke in controlled fire in bldg, init', '2018-03-02 00:00:00+00', 89, 28, 33, 17);
INSERT INTO task VALUES (2, 'quisque id justo sit amet', 'Displ seg fx shaft of r fibula, 7thQ', '2018-01-13 00:00:00+00', 32, 33, 34, 18);
INSERT INTO task VALUES (3, 'maecenas tincidunt lacus at', 'Injury of other muscles, fascia and tendons at forearm level', '2017-07-11 00:00:00+01', 31, 9, 69, 19);
INSERT INTO task VALUES (4, 'non mauris morbi non lectus aliquam', 'Laceration with foreign body of unsp elbow, init encntr', '2017-05-14 00:00:00+01', 55, 75, 76, 16);
INSERT INTO task VALUES (5, 'augue', 'Inj oth blood vessels at wrist and hand level of left arm', '2017-07-30 00:00:00+01', 55, 74, 44, 16);
INSERT INTO task VALUES (6, 'duis aliquam convallis nunc proin at', 'Puncture wound without foreign body, right hip, subs encntr', '2017-12-10 00:00:00+00', 57, 91, 26, 19);
INSERT INTO task VALUES (7, 'cras non velit nec', 'Secondary osteoarthritis, left shoulder', '2018-02-24 00:00:00+00', 32, 30, 45, 8);
INSERT INTO task VALUES (8, 'libero quis', 'Strain flxr musc/fasc/tend l little fngr at wrs/hnd lv, subs', '2017-06-24 00:00:00+01', 26, 33, 75, 16);
INSERT INTO task VALUES (9, 'commodo vulputate justo in', 'Hallux varus (acquired), unspecified foot', '2017-05-20 00:00:00+01', 16, 18, 39, 12);
INSERT INTO task VALUES (10, 'sed vestibulum sit amet cursus', 'Nondisp commnt fx shaft of unsp tibia, 7thR', '2017-10-10 00:00:00+01', 86, 81, 47, 16);
INSERT INTO task VALUES (11, 'convallis nulla neque libero convallis eget', 'Person outsd bus inj in clsn w statnry object nontraf, init', '2018-03-18 00:00:00+00', 39, 88, 77, 8);
INSERT INTO task VALUES (12, 'mauris', 'Disp fx of epiphy (separation) (upper) of r femur, sequela', '2018-01-24 00:00:00+00', 42, 93, 49, 27);
INSERT INTO task VALUES (13, 'phasellus', 'Underdosing of antimycobacterial drugs, initial encounter', '2018-02-24 00:00:00+00', 52, 98, 21, 21);
INSERT INTO task VALUES (14, 'augue vestibulum ante', 'Pnctr w/o fb of unsp eyelid and periocular area, subs', '2017-07-16 00:00:00+01', 49, 67, 5, 13);
INSERT INTO task VALUES (15, 'et ultrices posuere cubilia curae mauris', 'Acquired absence of other toe(s)', '2017-10-22 00:00:00+01', 10, 32, 45, 15);
INSERT INTO task VALUES (16, 'dui maecenas tristique est et', 'Rupture of synovium, unspecified toe(s)', '2017-05-03 00:00:00+01', 10, 10, 68, 15);
INSERT INTO task VALUES (17, 'in hac habitasse', 'Partial traumatic amp of left shldr/up arm, level unsp, init', '2017-11-28 00:00:00+00', 91, 52, 14, 30);
INSERT INTO task VALUES (18, 'posuere nonummy integer non', 'Driver of hv veh inj in clsn w nonmtr vehicle in traf, init', '2017-08-17 00:00:00+01', 73, 13, 22, 24);
INSERT INTO task VALUES (19, 'nibh quisque id justo sit amet', 'Other sprain of right shoulder joint, subsequent encounter', '2017-11-13 00:00:00+00', 58, 9, 23, 5);
INSERT INTO task VALUES (20, 'ultricies eu nibh quisque', 'Nondisp fx of greater trochanter of unsp femr, 7thH', '2017-12-17 00:00:00+00', 73, 17, 95, 12);
INSERT INTO task VALUES (21, 'maecenas', 'Oth fx shaft of left femur, init for opn fx type 3A/B/C', '2018-03-12 00:00:00+00', 90, 84, 92, 11);
INSERT INTO task VALUES (22, 'vestibulum ante ipsum primis', 'Nondisp seg fx shaft of ulna, l arm, 7thB', '2018-03-16 00:00:00+00', 8, 63, 71, 14);
INSERT INTO task VALUES (23, 'nisi eu orci mauris lacinia', 'Embolism due to nervous system prosth dev/grft', '2017-04-06 00:00:00+01', 47, 51, 58, 26);
INSERT INTO task VALUES (24, 'congue etiam justo etiam pretium iaculis', 'Hypertrophic disorders of skin', '2018-03-16 00:00:00+00', 56, 73, 99, 10);
INSERT INTO task VALUES (25, 'suscipit a', 'Other specified arthritis, right ankle and foot', '2017-09-22 00:00:00+01', 31, 33, 69, 10);
INSERT INTO task VALUES (26, 'faucibus', 'Sltr-haris Type II physl fx upr end l fibula, 7thG', '2017-05-02 00:00:00+01', 14, 94, 80, 9);
INSERT INTO task VALUES (27, 'ipsum praesent blandit lacinia erat', 'Lacerat unsp musc/fasc/tend at wrs/hnd lv, left hand, subs', '2018-02-09 00:00:00+00', 50, 48, 78, 24);
INSERT INTO task VALUES (28, 'eros viverra', 'Sympathetic uveitis, bilateral', '2018-02-09 00:00:00+00', 80, 91, 21, 3);
INSERT INTO task VALUES (29, 'pellentesque quisque porta volutpat erat quisque', 'Dislocation of unsp interphaln joint of r idx fngr, sequela', '2017-04-07 00:00:00+01', 11, 53, 95, 9);
INSERT INTO task VALUES (30, 'vel augue vestibulum ante', 'Crushing injury of unspecified lower leg', '2017-10-24 00:00:00+01', 89, 62, 15, 26);
INSERT INTO task VALUES (31, 'at velit eu est congue elementum', 'Unsp athscl type of bypass of the extremities, right leg', '2017-03-31 00:00:00+01', 22, 23, 92, 19);
INSERT INTO task VALUES (32, 'ut nulla sed accumsan felis', 'Displ seg fx shaft of ulna, r arm, 7thF', '2017-04-20 00:00:00+01', 89, 65, 36, 28);
INSERT INTO task VALUES (33, 'sed nisl nunc rhoncus dui', 'Gastroduodenitis, unspecified', '2017-09-27 00:00:00+01', 63, 42, 97, 14);
INSERT INTO task VALUES (34, 'in faucibus orci luctus', 'Burn of second degree of left palm, sequela', '2018-01-29 00:00:00+00', 46, 26, 13, 18);
INSERT INTO task VALUES (35, 'rhoncus aliquam', 'Hypertrophy of vulva', '2017-06-01 00:00:00+01', 27, 76, 49, 8);
INSERT INTO task VALUES (36, 'congue etiam', 'Chimera 46, XX/46, XY', '2017-07-20 00:00:00+01', 66, 48, 12, 2);
INSERT INTO task VALUES (37, 'sit amet eleifend pede libero', 'Underdosing of barbiturates, initial encounter', '2017-11-13 00:00:00+00', 44, 77, 92, 11);
INSERT INTO task VALUES (38, 'tellus nulla ut erat id mauris', 'Poisoning by keratolyt/keratplst/hair trmt drug, acc, init', '2017-05-29 00:00:00+01', 8, 69, 1, 30);
INSERT INTO task VALUES (39, 'orci luctus et ultrices posuere', 'Inflammatory disorders of seminal vesicle', '2017-09-19 00:00:00+01', 26, 37, 59, 23);
INSERT INTO task VALUES (40, 'tristique in tempus sit amet', 'Contracture of muscle, right thigh', '2017-11-15 00:00:00+00', 26, 8, 4, 15);
INSERT INTO task VALUES (41, 'primis in faucibus orci luctus', 'Juvenile myoclonic epilepsy [impulsive petit mal]', '2017-11-08 00:00:00+00', 32, 68, 24, 19);
INSERT INTO task VALUES (42, 'eget tincidunt eget tempus vel pede', 'Wear of artic bearing surface of internal prosth l hip jt', '2018-02-20 00:00:00+00', 27, 75, 76, 23);
INSERT INTO task VALUES (43, 'at nunc commodo placerat praesent blandit', 'Stromal corneal pigmentations', '2018-01-27 00:00:00+00', 85, 65, 57, 15);
INSERT INTO task VALUES (44, 'et magnis', 'Path fx in oth disease, l ulna, subs for fx w delay heal', '2017-08-17 00:00:00+01', 50, 36, 53, 10);
INSERT INTO task VALUES (45, 'nisi eu', 'Disp fx of medial phalanx of finger, subs for fx w nonunion', '2017-09-20 00:00:00+01', 91, 1, 97, 30);
INSERT INTO task VALUES (46, 'ut erat id mauris', 'Mech compl of other cardiac electronic device, init encntr', '2017-03-20 00:00:00+00', 91, 32, 91, 30);
INSERT INTO task VALUES (47, 'imperdiet nullam orci pede venenatis', 'Osteopathy in diseases classified elsewhere, unsp upper arm', '2017-05-05 00:00:00+01', 46, 99, 2, 11);
INSERT INTO task VALUES (48, 'morbi non quam nec dui luctus', 'Displaced associated transv/post fx left acetabulum, init', '2018-01-20 00:00:00+00', 45, 45, 74, 17);
INSERT INTO task VALUES (49, 'massa', 'Acute lacrimal canaliculitis of unspecified lacrimal passage', '2018-02-16 00:00:00+00', 57, 44, 85, 21);
INSERT INTO task VALUES (50, 'faucibus orci luctus et ultrices posuere', 'Legal intervention involving manhandling', '2017-03-26 00:00:00+00', 57, 96, 55, 28);
INSERT INTO task VALUES (51, 'nullam porttitor lacus', 'Other hyperfunction of pituitary gland', '2018-01-29 00:00:00+00', 64, 16, 41, 21);
INSERT INTO task VALUES (52, 'sapien urna', 'Milt op involving oth explosn and fragmt, civilian, sequela', '2017-03-23 00:00:00+00', 32, 23, 17, 9);
INSERT INTO task VALUES (53, 'massa', 'Bitten by raccoon', '2017-06-29 00:00:00+01', 56, 87, 99, 24);
INSERT INTO task VALUES (54, 'rutrum at lorem integer', 'Inj oth blood vessels at shldr/up arm, right arm', '2017-08-27 00:00:00+01', 70, 44, 48, 14);
INSERT INTO task VALUES (55, 'praesent id massa id', 'Fracture of base of skull', '2017-04-15 00:00:00+01', 26, 98, 69, 23);
INSERT INTO task VALUES (56, 'turpis sed ante vivamus', 'Episcleritis periodica fugax, bilateral', '2017-04-28 00:00:00+01', 87, 67, 33, 4);
INSERT INTO task VALUES (57, 'cubilia curae mauris viverra', 'Other secondary chronic gout, right knee, with tophus', '2017-04-19 00:00:00+01', 72, 26, 42, 20);
INSERT INTO task VALUES (58, 'vulputate vitae nisl aenean lectus', 'Severely displaced Zone II fx sacrum, subs for fx w nonunion', '2018-03-12 00:00:00+00', 23, 40, 13, 10);
INSERT INTO task VALUES (59, 'penatibus et magnis dis', 'Unspecified water transport accident, initial encounter', '2017-04-29 00:00:00+01', 80, 75, 47, 18);
INSERT INTO task VALUES (60, 'nullam orci pede venenatis non sodales', 'Toxic effect of phenol and phenol homologues, undetermined', '2017-04-09 00:00:00+01', 45, 94, 89, 1);
INSERT INTO task VALUES (61, 'tincidunt lacus at velit', 'Type 2 diab with diab mclr edema, resolved fol trtmt, unsp', '2017-08-17 00:00:00+01', 87, 7, 50, 30);
INSERT INTO task VALUES (62, 'in consequat', 'Pathological fracture, left foot, subs for fx w delay heal', '2018-02-16 00:00:00+00', 90, 32, 24, 7);
INSERT INTO task VALUES (63, 'sit amet nulla quisque arcu', 'Open bite of unspecified hand, sequela', '2017-10-29 00:00:00+01', 16, 72, 64, 10);
INSERT INTO task VALUES (64, 'urna ut tellus nulla', 'Mtrcy driver injured in collision w pedl cyc in traf, init', '2017-05-06 00:00:00+01', 94, 35, 99, 22);
INSERT INTO task VALUES (65, 'nisl nunc', 'Agoraphobia without panic disorder', '2017-10-21 00:00:00+01', 74, 66, 86, 10);
INSERT INTO task VALUES (66, 'nulla elit ac nulla sed', 'External constriction of left ear, initial encounter', '2018-03-18 00:00:00+00', 94, 66, 40, 13);
INSERT INTO task VALUES (67, 'consequat lectus in est risus', 'Disp fx of medial phalanx of right middle finger, sequela', '2017-04-14 00:00:00+01', 8, 29, 50, 10);
INSERT INTO task VALUES (68, 'suspendisse potenti cras in purus eu', 'Dislocation of other parts of thorax, subsequent encounter', '2017-11-27 00:00:00+00', 18, 50, 2, 15);
INSERT INTO task VALUES (69, 'viverra dapibus nulla suscipit', 'Unspecified open wound of thigh', '2017-05-15 00:00:00+01', 51, 23, 4, 20);
INSERT INTO task VALUES (70, 'quam nec dui', 'Underdosing of unspecified psychostimulants, subs encntr', '2017-10-28 00:00:00+01', 20, 58, 79, 25);
INSERT INTO task VALUES (71, 'lorem vitae mattis nibh ligula nec', 'Toxic eff of carb monx from mtr veh exhaust, slf-hrm, sqla', '2017-04-21 00:00:00+01', 79, 34, 38, 15);
INSERT INTO task VALUES (72, 'mauris eget massa', 'Path fracture in oth disease, l foot, subs for fx w nonunion', '2017-06-03 00:00:00+01', 56, 69, 6, 18);
INSERT INTO task VALUES (73, 'sit amet', 'Displaced dome fx left talus, subs for fx w malunion', '2017-11-01 00:00:00+00', 76, 50, 17, 18);
INSERT INTO task VALUES (74, 'sociis natoque penatibus et magnis', 'Sltr-haris Type I physl fx low end ulna, l arm, 7thD', '2018-01-07 00:00:00+00', 51, 33, 46, 15);
INSERT INTO task VALUES (75, 'sem fusce consequat nulla', 'Air embolism in pregnancy, unspecified trimester', '2018-03-18 00:00:00+00', 57, 14, 3, 29);
INSERT INTO task VALUES (76, 'semper interdum mauris', 'Disp fx of acromial pro, l shldr, subs for fx w delay heal', '2017-03-30 00:00:00+01', 87, 98, 39, 13);
INSERT INTO task VALUES (77, 'enim sit amet nunc viverra dapibus', 'Sltr-haris Type IV physeal fracture of left metatarsal, 7thK', '2018-01-30 00:00:00+00', 58, 42, 87, 11);
INSERT INTO task VALUES (78, 'ante', 'Nondisp fx of shaft of 3rd MC bone, r hand, 7thK', '2017-10-21 00:00:00+01', 4, 14, 87, 16);
INSERT INTO task VALUES (79, 'erat quisque erat', 'Chorioretinal scars after surgery for detachment, left eye', '2017-07-25 00:00:00+01', 43, 67, 70, 19);
INSERT INTO task VALUES (80, 'nunc rhoncus dui vel', 'Occup of bus injured in nonclsn trnsp acc nontraf, sequela', '2017-07-02 00:00:00+01', 76, 11, 90, 26);
INSERT INTO task VALUES (81, 'luctus tincidunt nulla mollis molestie', 'Spinal muscular atrophy, unspecified', '2017-08-18 00:00:00+01', 45, 13, 39, 25);
INSERT INTO task VALUES (82, 'cubilia curae mauris viverra', 'Sprain of chondrosternal joint, sequela', '2017-04-04 00:00:00+01', 26, 18, 30, 9);
INSERT INTO task VALUES (83, 'ut', 'Malignant neoplasm of axillary tail of unsp male breast', '2017-12-11 00:00:00+00', 5, 14, 72, 26);
INSERT INTO task VALUES (84, 'sed augue', 'Other fracture of left femur', '2017-10-15 00:00:00+01', 76, 60, 21, 21);
INSERT INTO task VALUES (85, 'fusce consequat nulla nisl', 'Intravaginal torsion of spermatic cord', '2017-07-25 00:00:00+01', 2, 57, 64, 16);
INSERT INTO task VALUES (86, 'nunc vestibulum ante ipsum primis in', 'Other injury of ascending [right] colon', '2017-06-09 00:00:00+01', 43, 1, 89, 29);
INSERT INTO task VALUES (87, 'mi sit amet lobortis sapien', 'Other mucopurulent conjunctivitis', '2017-06-20 00:00:00+01', 82, 33, 66, 11);
INSERT INTO task VALUES (88, 'luctus et ultrices posuere cubilia curae', 'Leakage of indwelling urethral catheter, initial encounter', '2017-07-10 00:00:00+01', 69, 94, 13, 21);
INSERT INTO task VALUES (89, 'aenean fermentum donec ut mauris', 'Nondisp fx of cuboid bone of right foot, init for opn fx', '2018-03-16 00:00:00+00', 60, 12, 82, 16);
INSERT INTO task VALUES (90, 'pellentesque ultrices mattis', 'Manic episode, severe with psychotic symptoms', '2018-02-18 00:00:00+00', 35, 83, 48, 16);
INSERT INTO task VALUES (91, 'pellentesque', 'Epidural hemorrhage w LOC of 1-5 hrs 59 min, init', '2017-12-20 00:00:00+00', 71, 39, 21, 12);
INSERT INTO task VALUES (92, 'in eleifend quam a odio in', 'Burns of 60-69% of body surfc w 0% to 9% third degree burns', '2018-02-24 00:00:00+00', 55, 24, 99, 29);
INSERT INTO task VALUES (93, 'nec euismod scelerisque quam turpis', 'Lac w/o fb of low back and pelv w/o penet retroperiton, init', '2017-05-06 00:00:00+01', 79, 92, 64, 5);
INSERT INTO task VALUES (94, 'lobortis convallis tortor risus', 'Laceration with foreign body of larynx, initial encounter', '2017-06-02 00:00:00+01', 83, 29, 56, 12);
INSERT INTO task VALUES (95, 'libero nam dui proin leo odio', 'Burn of cornea and conjunctival sac, unsp eye, init encntr', '2017-07-31 00:00:00+01', 61, 78, 27, 6);
INSERT INTO task VALUES (96, 'in tempus sit amet', 'Algoneurodystrophy, right hand', '2018-03-17 00:00:00+00', 47, 51, 42, 10);
INSERT INTO task VALUES (97, 'proin leo', 'Nondisp fx of dist phalanx of l rng fngr, 7thP', '2017-07-31 00:00:00+01', 39, 76, 37, 1);
INSERT INTO task VALUES (98, 'posuere', 'Lac w/o fb of abd wall, left lower q w penet perit cav, subs', '2017-05-09 00:00:00+01', 77, 79, 56, 23);
INSERT INTO task VALUES (99, 'praesent blandit nam', 'Nondisp fx of med condyle of r tibia, 7thQ', '2018-02-23 00:00:00+00', 13, 50, 46, 1);
INSERT INTO task VALUES (100, 'volutpat convallis', 'Passenger of special construct vehicle injured nontraf, init', '2017-03-24 00:00:00+00', 100, 52, 53, 29);
INSERT INTO task VALUES (101, 'ipsum primis in', 'Breakdown (mechanical) of int fix of right humerus', '2018-01-29 00:00:00+00', 65, 92, 21, 4);
INSERT INTO task VALUES (102, 'eleifend quam', 'Tuberculosis complicating pregnancy, unspecified trimester', '2017-09-20 00:00:00+01', 65, 67, 69, 21);
INSERT INTO task VALUES (103, 'enim', 'Milt op w unsp fire/conflagr/hot subst, milt, sequela', '2017-08-10 00:00:00+01', 70, 58, 51, 6);
INSERT INTO task VALUES (104, 'ut nulla sed accumsan', 'Abscess of eyelid', '2017-08-29 00:00:00+01', 29, 45, 36, 30);
INSERT INTO task VALUES (105, 'vestibulum ante', 'Puncture wound with foreign body of unsp wrist, sequela', '2017-11-10 00:00:00+00', 50, 86, 63, 3);
INSERT INTO task VALUES (106, 'volutpat dui maecenas tristique', 'Lacerat msl/tnd lng flxr msl toe at ank/ft lev,unsp ft, sqla', '2018-03-01 00:00:00+00', 85, 65, 41, 12);
INSERT INTO task VALUES (107, 'tellus', 'Unsp physeal fracture of upper end radius, left arm, sequela', '2017-04-04 00:00:00+01', 13, 50, 56, 20);
INSERT INTO task VALUES (108, 'purus aliquet at', 'Toxic effect of unspecified snake venom, assault, sequela', '2017-09-11 00:00:00+01', 52, 10, 32, 20);
INSERT INTO task VALUES (109, 'aliquam', 'Milt op involving oth conventional warfare, milt, subs', '2017-10-17 00:00:00+01', 84, 33, 92, 6);
INSERT INTO task VALUES (110, 'ut rhoncus aliquet pulvinar sed', 'Open bite, right lower leg, initial encounter', '2017-10-26 00:00:00+01', 84, 80, 6, 16);
INSERT INTO task VALUES (111, 'quam pharetra magna ac consequat', 'Other contact with other birds, sequela', '2018-02-08 00:00:00+00', 74, 82, 48, 22);
INSERT INTO task VALUES (112, 'hendrerit at', 'Puncture wound without foreign body of unsp part of neck', '2017-10-27 00:00:00+01', 33, 89, 16, 10);
INSERT INTO task VALUES (113, 'eleifend quam', 'Frostbite with tissue necrosis of ear', '2017-09-11 00:00:00+01', 71, 46, 99, 5);
INSERT INTO task VALUES (114, 'lobortis convallis tortor risus', 'Burn of second degree of unspecified ear, initial encounter', '2018-01-15 00:00:00+00', 27, 67, 58, 1);
INSERT INTO task VALUES (115, 'semper rutrum nulla nunc purus phasellus', 'Unsp inj extn musc/fasc/tend r mid fngr at wrs/hnd lv, sqla', '2017-12-01 00:00:00+00', 62, 91, 73, 26);
INSERT INTO task VALUES (116, 'dui', 'Disp fx of acromial process, l shldr, subs for fx w malunion', '2017-11-07 00:00:00+00', 61, 80, 20, 30);
INSERT INTO task VALUES (117, 'elementum ligula vehicula', 'Leakage of indwelling urethral catheter, subs', '2017-10-25 00:00:00+01', 72, 40, 61, 21);
INSERT INTO task VALUES (118, 'diam', 'Pnctr w/o foreign body of right cheek and TMJ area, sequela', '2017-09-08 00:00:00+01', 81, 43, 94, 2);
INSERT INTO task VALUES (119, 'id lobortis convallis tortor risus', 'Disp fx of medial phalanx of left middle finger, init', '2017-09-07 00:00:00+01', 33, 50, 97, 19);
INSERT INTO task VALUES (120, 'id pretium iaculis diam erat', 'Squamous cell carcinoma of skin of and unsp parts of face', '2018-02-20 00:00:00+00', 61, 61, 13, 28);
INSERT INTO task VALUES (121, 'auctor gravida sem praesent', 'Disorders of visual pathways in (due to) neoplasm, unsp side', '2017-04-28 00:00:00+01', 48, 90, 7, 2);
INSERT INTO task VALUES (122, 'sed justo pellentesque viverra pede ac', 'Poisoning by unsp general anesthetics, self-harm, init', '2018-03-10 00:00:00+00', 58, 11, 94, 10);
INSERT INTO task VALUES (123, 'sed', 'Mech compl of unspecified cardiac device, sequela', '2017-04-26 00:00:00+01', 48, 99, 3, 13);
INSERT INTO task VALUES (124, 'rhoncus sed', 'Immersion foot, left foot', '2018-03-11 00:00:00+00', 41, 70, 64, 6);
INSERT INTO task VALUES (125, 'non', 'Asphyxiation due to being trapped in a car trunk, self-harm', '2017-12-09 00:00:00+00', 94, 64, 68, 5);
INSERT INTO task VALUES (126, 'a', 'Peripheral T-cell lymphoma, not classified, intra-abd nodes', '2017-08-05 00:00:00+01', 33, 31, 11, 21);
INSERT INTO task VALUES (127, 'non pretium', 'Jump/div into natural body of water strk surfc causing drown', '2017-09-21 00:00:00+01', 91, 19, 56, 13);
INSERT INTO task VALUES (128, 'porta', 'Schizotypal disorder', '2017-12-23 00:00:00+00', 57, 15, 31, 18);
INSERT INTO task VALUES (129, 'sed justo', 'Strain of muscle, fascia and tendon of right hip, sequela', '2018-01-26 00:00:00+00', 17, 80, 10, 17);
INSERT INTO task VALUES (130, 'id ligula suspendisse ornare', 'Fracture of proximal third of navicular bone of wrist', '2017-09-10 00:00:00+01', 29, 10, 28, 21);
INSERT INTO task VALUES (131, 'sagittis dui vel nisl', 'Drug-induced chronic gout, left hand, without tophus (tophi)', '2017-07-22 00:00:00+01', 22, 46, 34, 15);
INSERT INTO task VALUES (132, 'vitae', 'Nondisp comminuted fx shaft of humerus, right arm, sequela', '2017-04-20 00:00:00+01', 67, 89, 2, 14);
INSERT INTO task VALUES (133, 'vel nisl duis', 'Fall (on)(from) incline, subsequent encounter', '2017-11-08 00:00:00+00', 90, 85, 72, 5);
INSERT INTO task VALUES (134, 'integer non', 'Cracked tooth', '2017-08-14 00:00:00+01', 85, 20, 97, 18);
INSERT INTO task VALUES (135, 'gravida nisi at', 'Episcleritis periodica fugax, bilateral', '2017-09-13 00:00:00+01', 54, 1, 69, 1);
INSERT INTO task VALUES (136, 'faucibus orci luctus et ultrices', 'Nondisp fx of epiphy (separation) (upper) of unsp femr, 7thF', '2017-10-04 00:00:00+01', 58, 23, 60, 30);
INSERT INTO task VALUES (137, 'lacus at turpis donec', 'Pedl cyc driver inj pick-up truck, pk-up/van nontraf, init', '2018-01-22 00:00:00+00', 84, 98, 3, 9);
INSERT INTO task VALUES (138, 'cubilia', 'Poisoning by oth agents aff the cardiovascular sys, assault', '2017-04-07 00:00:00+01', 78, 3, 41, 18);
INSERT INTO task VALUES (139, 'amet sapien dignissim', 'Chronic migraine w/o aura, intractable, w status migrainosus', '2017-03-20 00:00:00+00', 65, 65, 25, 13);
INSERT INTO task VALUES (140, 'ipsum dolor sit amet consectetuer adipiscing', 'Toxic effect of venom of other snake, undetermined', '2018-01-02 00:00:00+00', 89, 14, 16, 28);
INSERT INTO task VALUES (141, 'nulla', 'Toxic effect of contact w oth venomous plant, accidental', '2017-04-25 00:00:00+01', 77, 23, 50, 29);
INSERT INTO task VALUES (142, 'consectetuer adipiscing', 'Other congenital malformations of integument', '2017-11-08 00:00:00+00', 38, 3, 87, 19);
INSERT INTO task VALUES (143, 'sagittis', 'Nondisp spiral fx shaft of rad, r arm, 7thK', '2017-07-16 00:00:00+01', 95, 39, 27, 4);
INSERT INTO task VALUES (144, 'at dolor quis odio', 'Partial traumatic amputation of right midfoot, sequela', '2017-07-09 00:00:00+01', 69, 88, 96, 15);
INSERT INTO task VALUES (145, 'dolor', 'Unsp open wound of r little finger w damage to nail, init', '2017-04-21 00:00:00+01', 23, 18, 46, 30);
INSERT INTO task VALUES (146, 'in magna bibendum', 'Stress fracture, left foot, sequela', '2017-07-28 00:00:00+01', 53, 34, 96, 11);
INSERT INTO task VALUES (147, 'ornare consequat lectus in est', 'Displ commnt fx shaft of unsp fibula, 7thJ', '2018-02-26 00:00:00+00', 99, 21, 33, 2);
INSERT INTO task VALUES (148, 'ligula pellentesque ultrices phasellus id', 'Displ avuls fx tuberosity of r calcaneus, 7thP', '2017-06-12 00:00:00+01', 26, 81, 21, 8);
INSERT INTO task VALUES (149, 'volutpat dui maecenas', 'Nondisp commnt fx shaft of l tibia, 7thK', '2017-06-18 00:00:00+01', 39, 98, 33, 17);
INSERT INTO task VALUES (150, 'maecenas tincidunt lacus at velit', 'Displaced segmental fx shaft of ulna, right arm, init', '2017-12-10 00:00:00+00', 5, 60, 80, 6);
INSERT INTO task VALUES (151, 'neque libero', 'Retinal hemorrhage, left eye', '2017-09-13 00:00:00+01', 98, 54, 63, 9);
INSERT INTO task VALUES (152, 'libero rutrum ac lobortis', 'Benign neoplasm of colon, unspecified', '2017-09-08 00:00:00+01', 7, 74, 47, 3);
INSERT INTO task VALUES (153, 'est phasellus sit amet erat nulla', 'Suppurative otitis media, unspecified, unspecified ear', '2017-08-15 00:00:00+01', 9, 46, 3, 16);
INSERT INTO task VALUES (154, 'quam fringilla rhoncus mauris enim leo', 'Encounter for fit/adjst of non-vascular catheter', '2017-11-04 00:00:00+00', 30, 81, 65, 1);
INSERT INTO task VALUES (155, 'purus', 'Postprocedural (acute) (chronic) kidney failure', '2017-04-18 00:00:00+01', 15, 3, 85, 6);
INSERT INTO task VALUES (156, 'velit nec nisi', 'Ciguatera fish poisoning, undetermined', '2017-10-21 00:00:00+01', 79, 100, 15, 3);
INSERT INTO task VALUES (157, 'eros elementum pellentesque quisque porta', 'Contracture of muscle, forearm', '2017-08-20 00:00:00+01', 2, 38, 10, 23);
INSERT INTO task VALUES (158, 'fusce lacus purus aliquet', 'Poisoning by mixed bact vaccines w/o a pertuss, undet, init', '2017-08-22 00:00:00+01', 77, 78, 65, 26);
INSERT INTO task VALUES (159, 'neque libero convallis eget eleifend', 'Displ commnt fx shaft of l femr, 7thE', '2017-07-05 00:00:00+01', 83, 53, 85, 29);
INSERT INTO task VALUES (160, 'proin interdum mauris', 'Unspecified fracture of fourth thoracic vertebra', '2017-10-29 00:00:00+01', 88, 79, 50, 18);
INSERT INTO task VALUES (161, 'maecenas pulvinar lobortis', 'Other malformation of placenta, unspecified trimester', '2017-10-23 00:00:00+01', 89, 48, 57, 27);
INSERT INTO task VALUES (162, 'fusce congue diam id ornare', 'Superficial frostbite of thorax', '2018-03-05 00:00:00+00', 75, 38, 41, 7);
INSERT INTO task VALUES (163, 'mauris ullamcorper purus sit amet nulla', 'Injury of thoracic aorta', '2017-11-17 00:00:00+00', 58, 41, 92, 11);
INSERT INTO task VALUES (164, 'tellus in', 'Nontraumatic subarachnoid hemorrhage, unspecified', '2017-06-14 00:00:00+01', 67, 76, 28, 15);
INSERT INTO task VALUES (165, 'augue a suscipit', 'Unsp injury of other blood vessels of thorax, right side', '2018-01-06 00:00:00+00', 92, 41, 21, 25);
INSERT INTO task VALUES (166, 'in tempor', 'Lead-induced chronic gout, unspecified wrist, with tophus', '2017-05-24 00:00:00+01', 68, 85, 69, 22);
INSERT INTO task VALUES (167, 'sem sed sagittis', 'Unsp fracture of left calcaneus, subs for fx w malunion', '2017-05-02 00:00:00+01', 33, 96, 14, 11);
INSERT INTO task VALUES (168, 'suspendisse ornare consequat lectus in est', 'Contracture, right shoulder', '2017-04-29 00:00:00+01', 67, 23, 30, 22);
INSERT INTO task VALUES (169, 'amet turpis elementum ligula', 'Strain of intrinsic musc/fasc/tend r idx fngr at wrs/hnd lv', '2017-09-06 00:00:00+01', 17, 21, 18, 16);
INSERT INTO task VALUES (170, 'ante vel ipsum praesent', 'Adult neglect or abandonment, suspected', '2018-01-16 00:00:00+00', 45, 22, 39, 13);
INSERT INTO task VALUES (171, 'morbi', 'Nondisp fx of l ulna styloid pro, 7thN', '2017-09-04 00:00:00+01', 35, 95, 38, 30);
INSERT INTO task VALUES (172, 'varius ut blandit non interdum in', 'Postinfective urethral stricture, NEC, male, meatal', '2017-09-04 00:00:00+01', 40, 87, 37, 20);
INSERT INTO task VALUES (173, 'nec', 'Other shellfish poisoning, assault, initial encounter', '2017-08-09 00:00:00+01', 95, 23, 66, 26);
INSERT INTO task VALUES (174, 'dolor vel est donec', 'Posterior corneal pigmentations, unspecified eye', '2017-03-30 00:00:00+01', 47, 9, 41, 26);
INSERT INTO task VALUES (175, 'vehicula consequat morbi a ipsum', 'Disp fx of shaft of 3rd MC bone, l hand, 7thK', '2018-01-30 00:00:00+00', 61, 25, 12, 25);
INSERT INTO task VALUES (176, 'nam dui proin leo odio porttitor', 'Abnormal microbiological findings in cerebrospinal fluid', '2017-08-10 00:00:00+01', 57, 22, 59, 6);
INSERT INTO task VALUES (177, 'curae donec pharetra magna vestibulum', 'Insect bite (nonvenomous) of lip, initial encounter', '2017-04-26 00:00:00+01', 47, 39, 55, 26);
INSERT INTO task VALUES (178, 'rutrum neque aenean auctor gravida', 'Unsp inj flxr musc/fasc/tend l lit fngr at wrs/hnd lv, init', '2017-11-08 00:00:00+00', 13, 75, 84, 25);
INSERT INTO task VALUES (179, 'proin at turpis a', 'Drug-induced chronic gout, right knee, with tophus (tophi)', '2017-11-30 00:00:00+00', 71, 28, 33, 14);
INSERT INTO task VALUES (180, 'habitasse', 'Legal intervnt w unsp sharp objects, suspect injured, init', '2018-01-31 00:00:00+00', 1, 91, 25, 1);
INSERT INTO task VALUES (181, 'integer', 'Acquired absence of upper limb above elbow', '2018-03-16 00:00:00+00', 4, 36, 82, 28);
INSERT INTO task VALUES (182, 'lacinia nisi venenatis tristique', 'Congenital malformation of heart, unspecified', '2017-09-23 00:00:00+01', 18, 94, 32, 17);
INSERT INTO task VALUES (183, 'odio', 'Injury of oculomotor nerve, unspecified side', '2017-09-09 00:00:00+01', 73, 12, 9, 18);
INSERT INTO task VALUES (184, 'sit amet', 'Abrasion, right lesser toe(s), initial encounter', '2017-12-08 00:00:00+00', 30, 77, 69, 1);
INSERT INTO task VALUES (185, 'dui vel sem sed sagittis nam', 'Underdosing of unsp antipsychotics and neuroleptics, subs', '2017-05-21 00:00:00+01', 15, 88, 98, 24);
INSERT INTO task VALUES (186, 'tortor sollicitudin mi sit', 'Mechanical lagophthalmos right lower eyelid', '2017-10-17 00:00:00+01', 79, 17, 85, 20);
INSERT INTO task VALUES (187, 'non sodales sed', 'Oth physl fx upr end humer, unsp arm, 7thG', '2017-06-04 00:00:00+01', 97, 47, 19, 18);
INSERT INTO task VALUES (188, 'tellus nulla ut erat', 'Lacerat unsp blood vessel at lower leg level, unsp leg, subs', '2017-06-11 00:00:00+01', 7, 64, 29, 5);
INSERT INTO task VALUES (189, 'risus semper porta volutpat quam', 'Toxic effect of cobra venom, assault, initial encounter', '2018-01-11 00:00:00+00', 57, 42, 46, 24);
INSERT INTO task VALUES (190, 'sed sagittis nam', 'Burn of third degree of left ear [any part, except ear drum]', '2018-03-18 00:00:00+00', 13, 35, 71, 26);
INSERT INTO task VALUES (191, 'vestibulum quam sapien varius ut blandit', 'Inj unsp blood vessel at ank/ft level, left leg, sequela', '2017-04-16 00:00:00+01', 76, 7, 97, 4);
INSERT INTO task VALUES (192, 'dapibus at', 'Subluxation of distal interphaln joint of l rng fngr, init', '2018-01-16 00:00:00+00', 70, 91, 36, 3);
INSERT INTO task VALUES (193, 'velit nec nisi vulputate nonummy', 'Nondisp fx of prox phalanx of l idx fngr, 7thP', '2017-04-20 00:00:00+01', 75, 10, 63, 7);
INSERT INTO task VALUES (194, 'auctor gravida sem', 'Superficial frostbite of left ear, subsequent encounter', '2017-07-20 00:00:00+01', 73, 65, 53, 17);
INSERT INTO task VALUES (195, 'augue quam', 'Apraxia following cerebral infarction', '2017-11-22 00:00:00+00', 23, 99, 5, 25);
INSERT INTO task VALUES (196, 'odio cras mi', 'Disorders of muscle in diseases classd elswhr, r up arm', '2017-04-06 00:00:00+01', 51, 78, 90, 27);
INSERT INTO task VALUES (197, 'ante nulla justo aliquam quis', 'Strain of muscle, fascia and tendon of pelvis, subs encntr', '2017-06-19 00:00:00+01', 65, 9, 96, 6);
INSERT INTO task VALUES (198, 'in ante vestibulum ante ipsum', 'Nondisp fx of neck of third MC bone, l hand, init for opn fx', '2017-10-23 00:00:00+01', 65, 69, 75, 6);
INSERT INTO task VALUES (199, 'ante ipsum primis', 'Athscl nonaut bio bypass of the extrm w gangrene, bi legs', '2017-08-12 00:00:00+01', 49, 19, 59, 14);
INSERT INTO task VALUES (200, 'sodales sed tincidunt eu', 'Unsp intracapsular fracture of unspecified femur, sequela', '2018-02-28 00:00:00+00', 89, 60, 58, 14);
INSERT INTO task VALUES (201, 'at feugiat', 'Mallet finger of right finger(s)', '2017-04-05 00:00:00+01', 15, 90, 35, 28);
INSERT INTO task VALUES (202, 'gravida sem praesent id massa id', 'Mech compl of int fix of bones of foot and toes, sequela', '2017-04-24 00:00:00+01', 12, 18, 45, 27);
INSERT INTO task VALUES (203, 'suscipit ligula in lacus curabitur at', 'Abrasion, left ankle, sequela', '2017-10-24 00:00:00+01', 32, 21, 74, 3);
INSERT INTO task VALUES (204, 'tempor', 'Inj blood vessels at abdomen, low back and pelvis level', '2017-12-29 00:00:00+00', 58, 54, 26, 3);
INSERT INTO task VALUES (205, 'sagittis dui', 'Toxic eff of halgn deriv of aromatic hydrocrb, undet, subs', '2017-07-11 00:00:00+01', 28, 64, 40, 2);
INSERT INTO task VALUES (206, 'justo lacinia eget', 'Unstbl burst fx unsp lum vertebra, subs for fx w delay heal', '2017-08-02 00:00:00+01', 75, 66, 83, 27);
INSERT INTO task VALUES (207, 'nulla neque libero', 'Milt op involving oth conventional warfare, milt, init', '2017-08-01 00:00:00+01', 67, 64, 74, 15);
INSERT INTO task VALUES (208, 'vel pede morbi', 'Burn of second degree of unsp scapular region, init encntr', '2017-12-03 00:00:00+00', 24, 87, 3, 27);
INSERT INTO task VALUES (209, 'velit vivamus vel', 'Oth osteopor w crnt path fx, l low leg, 7thP', '2017-04-06 00:00:00+01', 75, 83, 43, 16);
INSERT INTO task VALUES (210, 'interdum mauris non ligula pellentesque ultrices', 'Maternal care for excess fetal growth, first trimester, unsp', '2017-04-03 00:00:00+01', 64, 5, 84, 10);
INSERT INTO task VALUES (211, 'potenti', 'Sltr-haris Type II physeal fracture of lower end of humerus', '2017-07-15 00:00:00+01', 52, 1, 30, 15);
INSERT INTO task VALUES (212, 'eget rutrum at lorem integer tincidunt', 'Unspecified injury of ascending colon, subsequent encounter', '2017-06-25 00:00:00+01', 24, 64, 32, 8);
INSERT INTO task VALUES (213, 'faucibus', 'Direct infct of r wrist in infec/parastc dis classd elswhr', '2017-10-16 00:00:00+01', 14, 9, 57, 23);
INSERT INTO task VALUES (214, 'luctus et ultrices', 'Other traumatic spondylolisthesis of fifth cervical vertebra', '2017-09-29 00:00:00+01', 72, 23, 1, 13);
INSERT INTO task VALUES (215, 'pellentesque volutpat dui maecenas tristique', 'Quad preg, unable to dtrm num plcnta & amnio sacs, 2nd tri', '2017-10-29 00:00:00+01', 100, 71, 48, 5);
INSERT INTO task VALUES (216, 'sit amet diam in magna', 'Polytrichia', '2017-09-30 00:00:00+01', 91, 83, 74, 2);
INSERT INTO task VALUES (217, 'morbi', 'Unspecified dislocation of left toe(s), subsequent encounter', '2017-06-20 00:00:00+01', 20, 59, 12, 4);
INSERT INTO task VALUES (218, 'sollicitudin ut suscipit a feugiat', 'Respiratory disorders in diseases classified elsewhere', '2017-08-24 00:00:00+01', 4, 4, 67, 21);
INSERT INTO task VALUES (219, 'venenatis', 'Other retained radioactive fragments', '2017-10-24 00:00:00+01', 94, 36, 6, 28);
INSERT INTO task VALUES (220, 'eu mi', 'Crushing injury of unspecified thumb, subsequent encounter', '2017-09-02 00:00:00+01', 72, 50, 15, 1);
INSERT INTO task VALUES (221, 'nec', 'Crushing injury of penis, initial encounter', '2017-09-14 00:00:00+01', 10, 20, 19, 20);
INSERT INTO task VALUES (222, 'leo rhoncus sed vestibulum', 'Laceration w foreign body of l idx fngr w damage to nail', '2017-11-20 00:00:00+00', 56, 94, 36, 27);
INSERT INTO task VALUES (223, 'turpis adipiscing lorem vitae mattis nibh', 'Oth traum nondisp spondylolysis of second cervcal vertebra', '2018-02-21 00:00:00+00', 54, 56, 7, 11);
INSERT INTO task VALUES (224, 'nisi nam ultrices libero', 'Benign lipomatous neoplasm of skin, subcu of left arm', '2017-10-19 00:00:00+01', 91, 11, 52, 12);
INSERT INTO task VALUES (225, 'cras pellentesque volutpat dui maecenas tristique', 'Abrasion, right lesser toe(s)', '2018-02-05 00:00:00+00', 98, 86, 94, 30);
INSERT INTO task VALUES (226, 'dui', 'Displ oblique fx shaft of l ulna, 7thR', '2017-07-03 00:00:00+01', 60, 88, 37, 9);
INSERT INTO task VALUES (227, 'proin at turpis a pede posuere', 'Injury of oth nerves at lower leg level, left leg, init', '2017-04-18 00:00:00+01', 17, 44, 20, 10);
INSERT INTO task VALUES (228, 'amet sem', 'Displaced oth extrartic fx r calcaneus, init for opn fx', '2017-05-17 00:00:00+01', 55, 3, 65, 2);
INSERT INTO task VALUES (229, 'nascetur ridiculus mus vivamus vestibulum', 'Displ transverse fx shaft of humer, r arm, 7thP', '2017-04-12 00:00:00+01', 43, 28, 34, 30);
INSERT INTO task VALUES (230, 'pede venenatis non', 'Unsp comp fol infusion and theraputc injection, sequela', '2017-11-09 00:00:00+00', 2, 71, 84, 5);
INSERT INTO task VALUES (231, 'etiam pretium iaculis justo', 'Sltr-haris Type II physl fx low end unsp tibia, 7thG', '2018-03-12 00:00:00+00', 48, 35, 21, 23);
INSERT INTO task VALUES (232, 'in eleifend', 'Injury of femoral nrv at hip and thi lev, right leg, init', '2018-01-11 00:00:00+00', 20, 71, 32, 22);
INSERT INTO task VALUES (233, 'ut erat curabitur gravida', 'Building under construction as place', '2017-07-01 00:00:00+01', 32, 27, 18, 12);
INSERT INTO task VALUES (234, 'posuere felis sed lacus', 'Strain flexor musc/fasc/tend l mid finger at forarm lv, sqla', '2017-08-04 00:00:00+01', 46, 26, 73, 19);
INSERT INTO task VALUES (235, 'varius nulla facilisi cras non', 'Postproc hematoma of eye and adnexa fol an opth procedure', '2018-03-03 00:00:00+00', 89, 98, 91, 16);
INSERT INTO task VALUES (236, 'interdum in ante vestibulum', 'Complete traumatic transphalangeal amputation of l idx fngr', '2017-08-16 00:00:00+01', 25, 32, 41, 5);
INSERT INTO task VALUES (237, 'nunc viverra', 'Terrorism involving unspecified means, initial encounter', '2017-06-26 00:00:00+01', 86, 69, 51, 15);
INSERT INTO task VALUES (238, 'id consequat in', 'Displ transverse fx shaft of unsp fibula, 7thD', '2017-11-07 00:00:00+00', 26, 65, 22, 1);
INSERT INTO task VALUES (239, 'ut massa quis augue luctus', 'Burn of unspecified degree of male genital region, sequela', '2017-11-06 00:00:00+00', 74, 19, 91, 3);
INSERT INTO task VALUES (240, 'eros suspendisse accumsan', 'Corrosion of third degree of forearm', '2017-06-29 00:00:00+01', 37, 83, 81, 22);
INSERT INTO task VALUES (241, 'velit id pretium iaculis diam erat', 'Varicose veins of left lower extremity with ulcer of calf', '2017-12-31 00:00:00+00', 67, 9, 7, 27);
INSERT INTO task VALUES (242, 'aliquet pulvinar sed nisl nunc', 'Displacement of other urinary catheter, subsequent encounter', '2018-02-08 00:00:00+00', 92, 64, 94, 3);
INSERT INTO task VALUES (243, 'habitasse platea dictumst maecenas ut massa', 'Exposure to other ionizing radiation, initial encounter', '2017-10-16 00:00:00+01', 85, 44, 77, 26);
INSERT INTO task VALUES (244, 'nisi at nibh', 'Alcoholic gastritis without bleeding', '2017-11-10 00:00:00+00', 48, 90, 88, 13);
INSERT INTO task VALUES (245, 'convallis nulla neque libero convallis', 'Poisn by unsp sys anti-infect and antiparastc, slf-hrm, sqla', '2018-01-14 00:00:00+00', 100, 58, 40, 9);
INSERT INTO task VALUES (246, 'quis augue luctus tincidunt', 'Postprocedural shock unspecified, sequela', '2017-07-13 00:00:00+01', 91, 60, 39, 28);
INSERT INTO task VALUES (247, 'et ultrices', 'Drugs acting on muscles', '2017-08-02 00:00:00+01', 80, 11, 5, 2);
INSERT INTO task VALUES (248, 'velit donec diam neque vestibulum', 'Underdosing of predominantly alpha-adrenocpt agonists, subs', '2017-12-12 00:00:00+00', 38, 7, 12, 28);
INSERT INTO task VALUES (249, 'id', 'Poisoning by chloramphenicol group, self-harm, init', '2017-12-13 00:00:00+00', 23, 100, 63, 13);
INSERT INTO task VALUES (250, 'nibh in hac habitasse platea', 'Exposure to ignition of oth clothing and apparel, subs', '2018-01-05 00:00:00+00', 37, 70, 83, 24);
INSERT INTO task VALUES (251, 'aliquet at', 'Idiopathic aseptic necrosis of right femur', '2017-07-14 00:00:00+01', 65, 56, 77, 27);
INSERT INTO task VALUES (252, 'cras mi pede malesuada in', 'Other injury of other part of colon, sequela', '2017-09-06 00:00:00+01', 67, 78, 52, 23);
INSERT INTO task VALUES (253, 'vestibulum aliquet ultrices erat', 'Other specified paralytic syndromes', '2017-10-12 00:00:00+01', 64, 95, 15, 3);
INSERT INTO task VALUES (254, 'feugiat et', 'Other chondrocalcinosis, vertebrae', '2017-04-29 00:00:00+01', 62, 79, 79, 5);
INSERT INTO task VALUES (255, 'duis', 'Gestational htn w/o significant proteinuria, unsp trimester', '2017-05-20 00:00:00+01', 80, 11, 22, 30);
INSERT INTO task VALUES (256, 'dis parturient montes nascetur', 'Fracture of ramus of left mandible, init', '2018-02-24 00:00:00+00', 32, 99, 46, 29);
INSERT INTO task VALUES (257, 'ipsum primis in', 'Puncture wound with foreign body of vagina and vulva', '2018-01-18 00:00:00+00', 54, 67, 10, 27);
INSERT INTO task VALUES (258, 'fusce posuere felis sed lacus', 'Displaced fracture of pisiform, right wrist', '2017-07-28 00:00:00+01', 83, 24, 71, 16);
INSERT INTO task VALUES (259, 'ipsum primis in', 'Incomplete lesion of L3 level of lumbar spinal cord', '2017-04-13 00:00:00+01', 32, 13, 17, 13);
INSERT INTO task VALUES (260, 'vel enim', 'Varicose veins of lower extremities w ulc and inflammation', '2017-09-10 00:00:00+01', 32, 88, 80, 22);
INSERT INTO task VALUES (261, 'eu', 'Drug/chem diab w neuro comp w diab autonm (poly)neuropathy', '2017-08-09 00:00:00+01', 13, 82, 83, 23);
INSERT INTO task VALUES (262, 'lorem id', 'Burn of unspecified degree of forearm', '2018-01-09 00:00:00+00', 69, 56, 13, 28);
INSERT INTO task VALUES (263, 'ut dolor', 'Anatomical narrow angle', '2017-10-08 00:00:00+01', 82, 62, 43, 2);
INSERT INTO task VALUES (264, 'dis parturient montes nascetur ridiculus', 'Oth disp fx of base of first MC bone, right hand, sequela', '2018-01-16 00:00:00+00', 42, 48, 36, 16);
INSERT INTO task VALUES (265, 'ullamcorper augue a suscipit nulla elit', 'Jump/div into oth water striking wall causing oth injury', '2017-03-27 00:00:00+01', 54, 75, 13, 22);
INSERT INTO task VALUES (266, 'in leo maecenas pulvinar', 'Poisoning by unspecified topical agent, assault, sequela', '2017-10-07 00:00:00+01', 68, 5, 49, 7);
INSERT INTO task VALUES (267, 'erat', 'Type 2 diab with prolif diab rtnop with macular edema, unsp', '2017-08-12 00:00:00+01', 24, 96, 59, 11);
INSERT INTO task VALUES (268, 'etiam pretium iaculis', 'Granuloma of orbit', '2017-03-26 00:00:00+00', 98, 62, 16, 7);
INSERT INTO task VALUES (269, 'vel lectus in quam', 'Open bite of unsp great toe without damage to nail, sequela', '2017-09-18 00:00:00+01', 42, 65, 20, 11);
INSERT INTO task VALUES (270, 'sit amet nulla quisque arcu libero', 'Chronic embolism and thrombosis of iliac vein', '2017-06-08 00:00:00+01', 24, 74, 81, 2);
INSERT INTO task VALUES (271, 'aenean lectus pellentesque eget nunc', 'Long term (current) use of hormonal contraceptives', '2018-01-13 00:00:00+00', 45, 54, 59, 19);
INSERT INTO task VALUES (272, 'molestie lorem', 'Intcran inj w LOC of unsp duration, sequela', '2017-09-23 00:00:00+01', 57, 50, 100, 15);
INSERT INTO task VALUES (273, 'in leo', 'Nonrheumatic aortic valve disorders', '2018-02-27 00:00:00+00', 9, 92, 52, 19);
INSERT INTO task VALUES (274, 'pede', 'Coma scale, best motor response, abnormal, in the field', '2018-01-12 00:00:00+00', 68, 61, 50, 2);
INSERT INTO task VALUES (275, 'duis bibendum felis sed', 'Fall from moving wheelchair (powered), sequela', '2017-07-24 00:00:00+01', 92, 40, 62, 1);
INSERT INTO task VALUES (276, 'neque sapien placerat', 'Discoid lupus erythematosus of right eye, unspecified eyelid', '2017-12-21 00:00:00+00', 67, 12, 26, 28);
INSERT INTO task VALUES (277, 'lectus pellentesque at nulla suspendisse', 'Milt op w direct blast effect of nuclear weapon, civ, subs', '2017-08-10 00:00:00+01', 17, 75, 62, 12);
INSERT INTO task VALUES (278, 'est donec odio', 'Other and unspecified asthma', '2017-06-29 00:00:00+01', 82, 57, 47, 7);
INSERT INTO task VALUES (279, 'elementum', 'Other forms of acute pericarditis', '2018-01-13 00:00:00+00', 95, 90, 69, 2);
INSERT INTO task VALUES (280, 'sem mauris laoreet ut', 'Person outside car injured in collision w 2/3-whl mv in traf', '2017-11-22 00:00:00+00', 73, 42, 81, 25);
INSERT INTO task VALUES (281, 'pede libero quis orci', 'Stress fracture, right finger(s), subs for fx w delay heal', '2017-12-10 00:00:00+00', 52, 96, 24, 10);
INSERT INTO task VALUES (282, 'placerat ante nulla justo aliquam quis', 'Nondisp oblique fx shaft of unsp ulna, 7thC', '2017-09-22 00:00:00+01', 13, 11, 65, 5);
INSERT INTO task VALUES (283, 'elementum pellentesque quisque porta volutpat erat', 'Other specified acquired deformities of left lower leg', '2017-07-03 00:00:00+01', 78, 6, 70, 27);
INSERT INTO task VALUES (284, 'massa', 'Oth injury of superficial palmar arch of unspecified hand', '2017-12-15 00:00:00+00', 32, 22, 36, 7);
INSERT INTO task VALUES (285, 'dapibus at diam nam', 'Miotic pupillary cyst, right eye', '2017-06-21 00:00:00+01', 95, 55, 72, 15);
INSERT INTO task VALUES (286, 'quam nec dui luctus rutrum', 'Unspecified injury of right renal artery, subs encntr', '2017-08-19 00:00:00+01', 77, 38, 26, 28);
INSERT INTO task VALUES (287, 'sapien iaculis congue vivamus', 'Incomplete atypical femoral fracture, right leg', '2017-06-05 00:00:00+01', 69, 18, 59, 9);
INSERT INTO task VALUES (288, 'nec dui luctus', 'Unspecified superficial injury of right ring finger, sequela', '2017-07-11 00:00:00+01', 50, 21, 42, 22);
INSERT INTO task VALUES (289, 'semper interdum mauris ullamcorper', 'Oth physeal fracture of lower end of unsp fibula, init', '2018-02-05 00:00:00+00', 91, 95, 64, 23);
INSERT INTO task VALUES (290, 'vel nisl duis ac', 'Infective myositis, unspecified site', '2017-05-30 00:00:00+01', 10, 86, 2, 26);
INSERT INTO task VALUES (291, 'adipiscing elit proin interdum mauris non', 'Benign neoplasm of thyroid gland', '2017-05-12 00:00:00+01', 23, 70, 22, 12);
INSERT INTO task VALUES (292, 'posuere', 'Breakdown of int fix of bones of hand and fingers, init', '2018-02-15 00:00:00+00', 82, 8, 5, 3);
INSERT INTO task VALUES (293, 'sapien', 'Sulfonamides', '2017-04-14 00:00:00+01', 14, 64, 22, 1);
INSERT INTO task VALUES (294, 'ultrices vel', 'Transient synovitis, right wrist', '2018-01-16 00:00:00+00', 92, 36, 30, 2);
INSERT INTO task VALUES (295, 'tortor risus dapibus augue vel accumsan', 'Acne tropica', '2017-09-04 00:00:00+01', 20, 77, 52, 28);
INSERT INTO task VALUES (296, 'ut massa volutpat convallis', 'Laceration with foreign body, left thigh, sequela', '2018-02-16 00:00:00+00', 55, 56, 58, 24);
INSERT INTO task VALUES (297, 'bibendum morbi non quam nec', 'Milt op w chem weapons and oth unconvtl warfare, milt, subs', '2017-08-06 00:00:00+01', 54, 68, 92, 22);
INSERT INTO task VALUES (298, 'vestibulum', 'Disp fx of distal pole of navicular bone of right wrist', '2017-07-11 00:00:00+01', 7, 33, 98, 25);
INSERT INTO task VALUES (299, 'in hac habitasse platea dictumst aliquam', 'Pedl cyc driver inj in clsn w oth pedl cyc in traf, sequela', '2017-08-29 00:00:00+01', 84, 4, 99, 22);
INSERT INTO task VALUES (300, 'hendrerit at vulputate', 'Unsp focal TBI w LOC of 1-5 hrs 59 min, init', '2018-02-20 00:00:00+00', 71, 93, 65, 25);


--
-- Data for Name: task_tag; Type: TABLE DATA; Schema: public; Owner: lbaw1614
--

INSERT INTO task_tag VALUES (29, 8);
INSERT INTO task_tag VALUES (89, 3);
INSERT INTO task_tag VALUES (39, 19);
INSERT INTO task_tag VALUES (4, 18);
INSERT INTO task_tag VALUES (33, 5);
INSERT INTO task_tag VALUES (62, 19);
INSERT INTO task_tag VALUES (67, 8);
INSERT INTO task_tag VALUES (43, 11);
INSERT INTO task_tag VALUES (23, 10);
INSERT INTO task_tag VALUES (40, 16);
INSERT INTO task_tag VALUES (14, 11);
INSERT INTO task_tag VALUES (98, 4);
INSERT INTO task_tag VALUES (3, 12);
INSERT INTO task_tag VALUES (23, 3);
INSERT INTO task_tag VALUES (53, 20);
INSERT INTO task_tag VALUES (90, 10);
INSERT INTO task_tag VALUES (80, 7);
INSERT INTO task_tag VALUES (58, 2);
INSERT INTO task_tag VALUES (65, 18);
INSERT INTO task_tag VALUES (34, 13);
INSERT INTO task_tag VALUES (1, 9);
INSERT INTO task_tag VALUES (11, 11);
INSERT INTO task_tag VALUES (34, 8);
INSERT INTO task_tag VALUES (52, 18);
INSERT INTO task_tag VALUES (38, 19);
INSERT INTO task_tag VALUES (50, 3);
INSERT INTO task_tag VALUES (94, 11);
INSERT INTO task_tag VALUES (8, 10);
INSERT INTO task_tag VALUES (51, 1);
INSERT INTO task_tag VALUES (53, 13);
INSERT INTO task_tag VALUES (38, 14);
INSERT INTO task_tag VALUES (85, 8);
INSERT INTO task_tag VALUES (1, 9);
INSERT INTO task_tag VALUES (78, 13);
INSERT INTO task_tag VALUES (62, 19);
INSERT INTO task_tag VALUES (86, 19);
INSERT INTO task_tag VALUES (38, 19);
INSERT INTO task_tag VALUES (92, 12);
INSERT INTO task_tag VALUES (3, 1);
INSERT INTO task_tag VALUES (89, 12);
INSERT INTO task_tag VALUES (66, 16);
INSERT INTO task_tag VALUES (87, 20);
INSERT INTO task_tag VALUES (39, 1);
INSERT INTO task_tag VALUES (21, 2);
INSERT INTO task_tag VALUES (45, 6);
INSERT INTO task_tag VALUES (98, 9);
INSERT INTO task_tag VALUES (20, 15);
INSERT INTO task_tag VALUES (78, 11);
INSERT INTO task_tag VALUES (2, 11);
INSERT INTO task_tag VALUES (9, 16);
INSERT INTO task_tag VALUES (29, 11);
INSERT INTO task_tag VALUES (21, 3);
INSERT INTO task_tag VALUES (5, 11);
INSERT INTO task_tag VALUES (51, 6);
INSERT INTO task_tag VALUES (52, 15);
INSERT INTO task_tag VALUES (44, 6);
INSERT INTO task_tag VALUES (30, 10);
INSERT INTO task_tag VALUES (42, 16);
INSERT INTO task_tag VALUES (26, 4);
INSERT INTO task_tag VALUES (92, 17);
INSERT INTO task_tag VALUES (19, 1);
INSERT INTO task_tag VALUES (89, 3);
INSERT INTO task_tag VALUES (31, 9);
INSERT INTO task_tag VALUES (16, 11);
INSERT INTO task_tag VALUES (60, 6);
INSERT INTO task_tag VALUES (63, 3);
INSERT INTO task_tag VALUES (62, 10);
INSERT INTO task_tag VALUES (45, 18);
INSERT INTO task_tag VALUES (41, 16);
INSERT INTO task_tag VALUES (86, 3);
INSERT INTO task_tag VALUES (17, 10);
INSERT INTO task_tag VALUES (31, 3);
INSERT INTO task_tag VALUES (85, 1);
INSERT INTO task_tag VALUES (19, 15);
INSERT INTO task_tag VALUES (28, 8);
INSERT INTO task_tag VALUES (58, 17);
INSERT INTO task_tag VALUES (16, 10);
INSERT INTO task_tag VALUES (71, 3);
INSERT INTO task_tag VALUES (89, 12);
INSERT INTO task_tag VALUES (75, 10);
INSERT INTO task_tag VALUES (77, 1);
INSERT INTO task_tag VALUES (7, 8);
INSERT INTO task_tag VALUES (42, 8);
INSERT INTO task_tag VALUES (16, 1);
INSERT INTO task_tag VALUES (41, 8);
INSERT INTO task_tag VALUES (74, 18);
INSERT INTO task_tag VALUES (62, 17);
INSERT INTO task_tag VALUES (10, 19);
INSERT INTO task_tag VALUES (19, 7);
INSERT INTO task_tag VALUES (98, 12);
INSERT INTO task_tag VALUES (8, 15);
INSERT INTO task_tag VALUES (12, 19);
INSERT INTO task_tag VALUES (82, 4);
INSERT INTO task_tag VALUES (64, 8);
INSERT INTO task_tag VALUES (55, 18);
INSERT INTO task_tag VALUES (25, 20);
INSERT INTO task_tag VALUES (97, 14);
INSERT INTO task_tag VALUES (73, 4);
INSERT INTO task_tag VALUES (54, 9);
INSERT INTO task_tag VALUES (69, 4);


--
-- Data for Name: user_meeting; Type: TABLE DATA; Schema: public; Owner: lbaw1614
--

INSERT INTO user_meeting VALUES (48, 83, false);
INSERT INTO user_meeting VALUES (37, 76, false);
INSERT INTO user_meeting VALUES (8, 1, false);
INSERT INTO user_meeting VALUES (70, 92, false);
INSERT INTO user_meeting VALUES (27, 76, false);
INSERT INTO user_meeting VALUES (82, 18, false);
INSERT INTO user_meeting VALUES (9, 52, false);
INSERT INTO user_meeting VALUES (47, 89, false);
INSERT INTO user_meeting VALUES (7, 8, false);
INSERT INTO user_meeting VALUES (82, 14, false);
INSERT INTO user_meeting VALUES (10, 83, false);
INSERT INTO user_meeting VALUES (32, 61, false);
INSERT INTO user_meeting VALUES (94, 92, false);
INSERT INTO user_meeting VALUES (21, 50, false);
INSERT INTO user_meeting VALUES (33, 52, false);
INSERT INTO user_meeting VALUES (76, 85, false);
INSERT INTO user_meeting VALUES (35, 79, false);
INSERT INTO user_meeting VALUES (15, 81, false);
INSERT INTO user_meeting VALUES (12, 87, false);
INSERT INTO user_meeting VALUES (2, 33, false);
INSERT INTO user_meeting VALUES (64, 70, false);
INSERT INTO user_meeting VALUES (37, 12, false);
INSERT INTO user_meeting VALUES (79, 17, false);
INSERT INTO user_meeting VALUES (61, 16, false);
INSERT INTO user_meeting VALUES (97, 78, false);
INSERT INTO user_meeting VALUES (67, 18, false);
INSERT INTO user_meeting VALUES (34, 51, false);
INSERT INTO user_meeting VALUES (83, 99, false);
INSERT INTO user_meeting VALUES (40, 79, false);
INSERT INTO user_meeting VALUES (69, 13, false);
INSERT INTO user_meeting VALUES (38, 91, false);
INSERT INTO user_meeting VALUES (15, 66, false);
INSERT INTO user_meeting VALUES (19, 86, false);
INSERT INTO user_meeting VALUES (52, 29, false);
INSERT INTO user_meeting VALUES (72, 99, false);
INSERT INTO user_meeting VALUES (55, 12, false);
INSERT INTO user_meeting VALUES (61, 67, false);
INSERT INTO user_meeting VALUES (60, 85, false);
INSERT INTO user_meeting VALUES (97, 77, false);
INSERT INTO user_meeting VALUES (32, 88, false);
INSERT INTO user_meeting VALUES (22, 90, false);
INSERT INTO user_meeting VALUES (57, 76, false);
INSERT INTO user_meeting VALUES (22, 69, false);
INSERT INTO user_meeting VALUES (16, 12, false);
INSERT INTO user_meeting VALUES (83, 23, false);
INSERT INTO user_meeting VALUES (18, 56, false);
INSERT INTO user_meeting VALUES (64, 13, false);
INSERT INTO user_meeting VALUES (50, 30, false);
INSERT INTO user_meeting VALUES (98, 30, false);
INSERT INTO user_meeting VALUES (90, 44, false);
INSERT INTO user_meeting VALUES (55, 27, false);
INSERT INTO user_meeting VALUES (11, 79, false);
INSERT INTO user_meeting VALUES (41, 29, false);
INSERT INTO user_meeting VALUES (20, 91, false);
INSERT INTO user_meeting VALUES (52, 88, false);
INSERT INTO user_meeting VALUES (24, 33, false);
INSERT INTO user_meeting VALUES (26, 72, false);
INSERT INTO user_meeting VALUES (6, 83, false);
INSERT INTO user_meeting VALUES (16, 49, false);
INSERT INTO user_meeting VALUES (51, 100, false);
INSERT INTO user_meeting VALUES (5, 96, false);
INSERT INTO user_meeting VALUES (88, 54, false);
INSERT INTO user_meeting VALUES (84, 26, false);
INSERT INTO user_meeting VALUES (13, 100, false);
INSERT INTO user_meeting VALUES (19, 76, false);
INSERT INTO user_meeting VALUES (56, 41, false);
INSERT INTO user_meeting VALUES (49, 39, false);
INSERT INTO user_meeting VALUES (68, 26, false);
INSERT INTO user_meeting VALUES (18, 21, false);
INSERT INTO user_meeting VALUES (59, 42, false);
INSERT INTO user_meeting VALUES (53, 72, false);
INSERT INTO user_meeting VALUES (32, 70, false);
INSERT INTO user_meeting VALUES (61, 85, false);
INSERT INTO user_meeting VALUES (73, 62, false);
INSERT INTO user_meeting VALUES (1, 100, false);
INSERT INTO user_meeting VALUES (70, 5, false);
INSERT INTO user_meeting VALUES (29, 94, false);
INSERT INTO user_meeting VALUES (8, 64, false);
INSERT INTO user_meeting VALUES (45, 34, false);
INSERT INTO user_meeting VALUES (71, 83, false);
INSERT INTO user_meeting VALUES (41, 87, false);
INSERT INTO user_meeting VALUES (64, 31, false);
INSERT INTO user_meeting VALUES (94, 17, false);
INSERT INTO user_meeting VALUES (63, 41, false);
INSERT INTO user_meeting VALUES (28, 30, false);
INSERT INTO user_meeting VALUES (59, 52, false);
INSERT INTO user_meeting VALUES (26, 51, false);
INSERT INTO user_meeting VALUES (23, 90, false);
INSERT INTO user_meeting VALUES (39, 64, false);
INSERT INTO user_meeting VALUES (99, 6, false);
INSERT INTO user_meeting VALUES (58, 23, false);
INSERT INTO user_meeting VALUES (72, 2, false);
INSERT INTO user_meeting VALUES (36, 8, false);
INSERT INTO user_meeting VALUES (12, 52, false);
INSERT INTO user_meeting VALUES (80, 73, false);
INSERT INTO user_meeting VALUES (95, 60, false);
INSERT INTO user_meeting VALUES (11, 18, false);
INSERT INTO user_meeting VALUES (19, 87, false);
INSERT INTO user_meeting VALUES (23, 20, false);
INSERT INTO user_meeting VALUES (64, 23, false);
INSERT INTO user_meeting VALUES (103, 1, true);
INSERT INTO user_meeting VALUES (48, 84, false);


--
-- Data for Name: user_project; Type: TABLE DATA; Schema: public; Owner: lbaw1614
--

INSERT INTO user_project VALUES (96, 26, true);
INSERT INTO user_project VALUES (29, 25, false);
INSERT INTO user_project VALUES (80, 20, false);
INSERT INTO user_project VALUES (41, 10, false);
INSERT INTO user_project VALUES (89, 21, false);
INSERT INTO user_project VALUES (41, 14, true);
INSERT INTO user_project VALUES (16, 3, false);
INSERT INTO user_project VALUES (34, 11, false);
INSERT INTO user_project VALUES (45, 1, false);
INSERT INTO user_project VALUES (42, 20, false);
INSERT INTO user_project VALUES (27, 5, true);
INSERT INTO user_project VALUES (57, 14, true);
INSERT INTO user_project VALUES (87, 1, false);
INSERT INTO user_project VALUES (15, 15, true);
INSERT INTO user_project VALUES (97, 16, false);
INSERT INTO user_project VALUES (67, 23, false);
INSERT INTO user_project VALUES (78, 28, false);
INSERT INTO user_project VALUES (67, 9, true);
INSERT INTO user_project VALUES (68, 27, false);
INSERT INTO user_project VALUES (39, 5, true);
INSERT INTO user_project VALUES (65, 3, true);
INSERT INTO user_project VALUES (51, 27, true);
INSERT INTO user_project VALUES (9, 30, true);
INSERT INTO user_project VALUES (56, 21, true);
INSERT INTO user_project VALUES (51, 29, true);
INSERT INTO user_project VALUES (1, 10, true);
INSERT INTO user_project VALUES (54, 6, false);
INSERT INTO user_project VALUES (79, 22, false);
INSERT INTO user_project VALUES (8, 14, true);
INSERT INTO user_project VALUES (73, 10, true);
INSERT INTO user_project VALUES (45, 22, false);
INSERT INTO user_project VALUES (5, 18, false);
INSERT INTO user_project VALUES (13, 21, false);
INSERT INTO user_project VALUES (11, 20, false);
INSERT INTO user_project VALUES (43, 1, true);
INSERT INTO user_project VALUES (87, 9, false);
INSERT INTO user_project VALUES (13, 20, false);
INSERT INTO user_project VALUES (35, 18, false);
INSERT INTO user_project VALUES (85, 11, false);
INSERT INTO user_project VALUES (53, 8, false);
INSERT INTO user_project VALUES (86, 27, false);
INSERT INTO user_project VALUES (14, 1, false);
INSERT INTO user_project VALUES (48, 23, true);
INSERT INTO user_project VALUES (84, 19, true);
INSERT INTO user_project VALUES (100, 8, true);
INSERT INTO user_project VALUES (95, 8, true);
INSERT INTO user_project VALUES (52, 22, true);
INSERT INTO user_project VALUES (80, 17, true);
INSERT INTO user_project VALUES (73, 1, false);
INSERT INTO user_project VALUES (90, 4, true);
INSERT INTO user_project VALUES (7, 19, true);
INSERT INTO user_project VALUES (79, 22, true);
INSERT INTO user_project VALUES (66, 13, false);
INSERT INTO user_project VALUES (82, 24, true);
INSERT INTO user_project VALUES (10, 23, true);
INSERT INTO user_project VALUES (24, 6, true);
INSERT INTO user_project VALUES (80, 8, false);
INSERT INTO user_project VALUES (98, 4, true);
INSERT INTO user_project VALUES (39, 27, false);
INSERT INTO user_project VALUES (27, 6, true);
INSERT INTO user_project VALUES (90, 25, true);
INSERT INTO user_project VALUES (60, 15, true);
INSERT INTO user_project VALUES (97, 10, true);
INSERT INTO user_project VALUES (51, 14, true);
INSERT INTO user_project VALUES (33, 9, false);
INSERT INTO user_project VALUES (37, 9, true);
INSERT INTO user_project VALUES (13, 16, false);
INSERT INTO user_project VALUES (18, 12, true);
INSERT INTO user_project VALUES (52, 5, true);
INSERT INTO user_project VALUES (63, 21, false);
INSERT INTO user_project VALUES (84, 8, false);
INSERT INTO user_project VALUES (42, 1, true);
INSERT INTO user_project VALUES (51, 12, true);
INSERT INTO user_project VALUES (39, 19, false);
INSERT INTO user_project VALUES (60, 19, false);
INSERT INTO user_project VALUES (24, 10, false);
INSERT INTO user_project VALUES (80, 14, true);
INSERT INTO user_project VALUES (71, 24, false);
INSERT INTO user_project VALUES (51, 26, false);
INSERT INTO user_project VALUES (17, 23, false);
INSERT INTO user_project VALUES (61, 25, false);
INSERT INTO user_project VALUES (55, 27, false);
INSERT INTO user_project VALUES (80, 9, true);
INSERT INTO user_project VALUES (14, 5, true);
INSERT INTO user_project VALUES (11, 29, true);
INSERT INTO user_project VALUES (6, 27, false);
INSERT INTO user_project VALUES (47, 24, true);
INSERT INTO user_project VALUES (89, 27, true);
INSERT INTO user_project VALUES (15, 5, false);
INSERT INTO user_project VALUES (31, 23, false);
INSERT INTO user_project VALUES (30, 5, false);
INSERT INTO user_project VALUES (47, 22, true);
INSERT INTO user_project VALUES (33, 13, true);
INSERT INTO user_project VALUES (73, 20, true);
INSERT INTO user_project VALUES (51, 8, true);
INSERT INTO user_project VALUES (65, 29, false);
INSERT INTO user_project VALUES (2, 24, true);
INSERT INTO user_project VALUES (58, 28, false);
INSERT INTO user_project VALUES (30, 13, false);
INSERT INTO user_project VALUES (10, 30, false);


--
-- Data for Name: user_table; Type: TABLE DATA; Schema: public; Owner: lbaw1614
--

INSERT INTO user_table VALUES (3, 'Pamela Price', 'pprice2', 'pprice2@gov.uk', 'TeziGujX', '84-(760)855-4725', 'vivamus.jpeg', '1975-04-12', 1, 'Porto');
INSERT INTO user_table VALUES (21, 'Christopher Carter', 'ccarterk', 'ccarterk@paypal.com', 'FKNfcs', '62-(212)448-4481', 'nulla pede.gif', '1995-09-15', 1, 'Porto');
INSERT INTO user_table VALUES (22, 'Ashley Hanson', 'ahansonl', 'ahansonl@senate.gov', 'XE7HGXBHCY', '62-(767)401-3062', 'eleifend donec.jpeg', '1985-04-19', 1, 'Porto');
INSERT INTO user_table VALUES (23, 'Victor Warren', 'vwarrenm', 'vwarrenm@usatoday.com', 'RTYcQq', '30-(561)360-9699', 'sem.jpeg', '1994-03-22', 1, 'Porto');
INSERT INTO user_table VALUES (24, 'Janice Johnson', 'jjohnsonn', 'jjohnsonn@smugmug.com', 'SdcT2VSn4', '63-(639)739-2231', 'ante vel.tiff', '1990-12-27', 1, 'Porto');
INSERT INTO user_table VALUES (25, 'Gregory Schmidt', 'gschmidto', 'gschmidto@vkontakte.ru', 'aJf5O5qv10', '58-(626)718-3377', 'et.jpeg', '1985-04-25', 1, 'Porto');
INSERT INTO user_table VALUES (26, 'Angela Morris', 'amorrisp', 'amorrisp@sogou.com', 'JwbMyx', '420-(472)452-6321', 'lobortis vel.jpeg', '1970-05-22', 1, 'Porto');
INSERT INTO user_table VALUES (27, 'Phyllis Watson', 'pwatsonq', 'pwatsonq@over-blog.com', 'luptsx', '48-(968)151-9052', 'leo.jpeg', '1985-02-16', 1, 'Porto');
INSERT INTO user_table VALUES (28, 'Earl Duncan', 'eduncanr', 'eduncanr@networksolutions.com', '2IvALfZ2KZmy', '93-(949)608-1245', 'nisl nunc nisl.tiff', '1975-06-03', 1, 'Porto');
INSERT INTO user_table VALUES (29, 'David Evans', 'devanss', 'devanss@slate.com', 'rdltLrvZEEDf', '84-(972)630-0984', 'hac habitasse.jpeg', '1982-10-09', 1, 'Porto');
INSERT INTO user_table VALUES (30, 'Scott Morrison', 'smorrisont', 'smorrisont@fc2.com', 'b9CYhX0wzIYT', '387-(259)859-8899', 'in hac.png', '1989-10-13', 1, 'Porto');
INSERT INTO user_table VALUES (31, 'Bobby Morgan', 'bmorganu', 'bmorganu@nhs.uk', 't4ZC4t85', '7-(276)785-2113', 'amet erat nulla.png', '1990-07-06', 1, 'Porto');
INSERT INTO user_table VALUES (32, 'Jesse Flores', 'jfloresv', 'jfloresv@yellowbook.com', 'tRIlazWy', '48-(196)352-6469', 'sed nisl nunc.tiff', '1977-12-06', 1, 'Porto');
INSERT INTO user_table VALUES (33, 'Timothy Dean', 'tdeanw', 'tdeanw@jalbum.net', 'jNkeaLV', '998-(751)848-2909', 'quis tortor.gif', '1988-07-10', 1, 'Porto');
INSERT INTO user_table VALUES (34, 'Kelly Garrett', 'kgarrettx', 'kgarrettx@go.com', 'Y8A5MgpKUPUZ', '591-(198)885-7571', 'platea dictumst.tiff', '1976-06-04', 1, 'Porto');
INSERT INTO user_table VALUES (35, 'Susan Wagner', 'swagnery', 'swagnery@indiatimes.com', 'y07yTSKE2XP', '7-(111)678-7261', 'orci.png', '1978-09-29', 1, 'Porto');
INSERT INTO user_table VALUES (36, 'Jane Wright', 'jwrightz', 'jwrightz@topsy.com', 'q4BE0Dnq', '86-(963)301-2200', 'erat curabitur.png', '1996-11-05', 1, 'Porto');
INSERT INTO user_table VALUES (37, 'Henry Henry', 'hhenry10', 'hhenry10@lulu.com', 'j9JUJybShZ', '86-(240)643-0589', 'ut mauris.png', '1977-07-27', 1, 'Porto');
INSERT INTO user_table VALUES (38, 'Brenda Olson', 'bolson11', 'bolson11@nasa.gov', 'uyRgmzPVg', '62-(384)565-4209', 'rhoncus.png', '1975-06-27', 1, 'Porto');
INSERT INTO user_table VALUES (39, 'Jose Lopez', 'jlopez12', 'jlopez12@patch.com', 'n1z2i3QfCoZ', '46-(214)610-1513', 'turpis enim blandit.jpeg', '1972-05-22', 1, 'Porto');
INSERT INTO user_table VALUES (40, 'Craig Simmons', 'csimmons13', 'csimmons13@twitpic.com', 'dJcYKitw', '62-(538)225-5544', 'aliquam.tiff', '1985-03-24', 1, 'Porto');
INSERT INTO user_table VALUES (41, 'Bruce Burns', 'bburns14', 'bburns14@ft.com', 'UOO6Y7Iac', '62-(386)538-1466', 'dis parturient.jpeg', '1991-04-10', 1, 'Porto');
INSERT INTO user_table VALUES (42, 'Mary Bradley', 'mbradley15', 'mbradley15@cargocollective.com', 'fouCV9QN8', '57-(974)573-5778', 'eget semper.jpeg', '1993-12-18', 1, 'Porto');
INSERT INTO user_table VALUES (43, 'Juan Murray', 'jmurray16', 'jmurray16@apache.org', 'c1mbJhylaXer', '7-(698)516-5974', 'amet cursus.tiff', '1987-04-16', 1, 'Porto');
INSERT INTO user_table VALUES (44, 'Helen Dean', 'hdean17', 'hdean17@google.fr', 'mk5hYZNc', '355-(212)717-3989', 'tortor.png', '1975-01-12', 1, 'Porto');
INSERT INTO user_table VALUES (45, 'Betty Crawford', 'bcrawford18', 'bcrawford18@illinois.edu', 'u59uRYi', '420-(814)415-3566', 'risus auctor sed.tiff', '1981-06-21', 1, 'Porto');
INSERT INTO user_table VALUES (46, 'Mark Dean', 'mdean19', 'mdean19@goodreads.com', 'W5GVpxRo35G', '30-(400)434-2808', 'amet sem.jpeg', '1970-07-19', 1, 'Porto');
INSERT INTO user_table VALUES (47, 'Jesse Cole', 'jcole1a', 'jcole1a@mysql.com', 'FcCaLv5zE', '63-(407)863-5738', 'nunc.tiff', '1974-06-01', 1, 'Porto');
INSERT INTO user_table VALUES (48, 'Kathryn Montgomery', 'kmontgomery1b', 'kmontgomery1b@1und1.de', '09YJirX6R', '86-(215)119-7820', 'ac est lacinia.tiff', '1988-02-02', 1, 'Porto');
INSERT INTO user_table VALUES (49, 'Ronald Dunn', 'rdunn1c', 'rdunn1c@mail.ru', 'PmNzJG7dN', '86-(990)705-6868', 'est congue.jpeg', '1993-11-16', 1, 'Porto');
INSERT INTO user_table VALUES (50, 'Cheryl Jackson', 'cjackson1d', 'cjackson1d@webnode.com', 'qs8t7n', '58-(543)998-3825', 'integer tincidunt.jpeg', '1998-12-23', 1, 'Porto');
INSERT INTO user_table VALUES (51, 'William Henry', 'whenry1e', 'whenry1e@mediafire.com', 'lX1xCD4k', '380-(321)245-7935', 'elementum eu.jpeg', '1995-02-24', 1, 'Porto');
INSERT INTO user_table VALUES (52, 'Timothy Wood', 'twood1f', 'twood1f@nationalgeographic.com', 'w3Rjmm5', '62-(801)575-4935', 'praesent.tiff', '1988-10-15', 1, 'Porto');
INSERT INTO user_table VALUES (53, 'Theresa Oliver', 'toliver1g', 'toliver1g@naver.com', 'sTU5PQ6Cd', '62-(785)211-0948', 'nam.gif', '1986-04-15', 1, 'Porto');
INSERT INTO user_table VALUES (54, 'Julie Olson', 'jolson1h', 'jolson1h@walmart.com', 'dkNkklp6x8NF', '45-(430)620-2540', 'eleifend pede libero.tiff', '1985-12-23', 1, 'Porto');
INSERT INTO user_table VALUES (55, 'Deborah Jacobs', 'djacobs1i', 'djacobs1i@harvard.edu', 'M64gCITi', '62-(347)556-4604', 'a.gif', '1977-12-23', 1, 'Porto');
INSERT INTO user_table VALUES (56, 'Cynthia Garrett', 'cgarrett1j', 'cgarrett1j@wisc.edu', 'pjSIMyUoXqL', '351-(965)123-7630', 'lacus.tiff', '1991-12-18', 1, 'Porto');
INSERT INTO user_table VALUES (57, 'Dennis King', 'dking1k', 'dking1k@google.pl', 'Nk95lC2jh', '57-(333)495-8624', 'dictumst maecenas.png', '1972-09-25', 1, 'Porto');
INSERT INTO user_table VALUES (58, 'Jeremy Hamilton', 'jhamilton1l', 'jhamilton1l@diigo.com', 'oFctCTA5F8l8', '86-(770)500-3943', 'aenean sit amet.gif', '1992-12-26', 1, 'Porto');
INSERT INTO user_table VALUES (59, 'Susan Henry', 'shenry1m', 'shenry1m@dailymotion.com', 'a9XsUBIcBIo', '48-(780)788-5746', 'ac est lacinia.jpeg', '1988-07-11', 1, 'Porto');
INSERT INTO user_table VALUES (60, 'Carolyn Brooks', 'cbrooks1n', 'cbrooks1n@about.com', '27FY0I2Q14L', '62-(805)830-8618', 'at lorem.jpeg', '1993-10-31', 1, 'Porto');
INSERT INTO user_table VALUES (2, 'Tina Bell', 'tbell1', 'tbell1@arstechnica.com', 'ZsDsUBLP003', '380-(964)515-7044', 'morbi porttitor lorem.jpeg', '1998-04-27', 1, 'Porto');
INSERT INTO user_table VALUES (62, 'Joshua Perkins', 'jperkins1p', 'jperkins1p@webs.com', 'hB8H6h', '54-(531)649-5542', 'proin.jpeg', '1971-05-27', 1, 'Porto');
INSERT INTO user_table VALUES (63, 'Edward Harper', 'eharper1q', 'eharper1q@umich.edu', 'pAomyNrks', '970-(519)710-1746', 'ipsum primis in.png', '1999-01-29', 1, 'Porto');
INSERT INTO user_table VALUES (64, 'Kelly Frazier', 'kfrazier1r', 'kfrazier1r@slideshare.net', '9aARbtu8b4T', '51-(516)223-3938', 'turpis.gif', '1975-05-22', 1, 'Porto');
INSERT INTO user_table VALUES (65, 'Ralph Webb', 'rwebb1s', 'rwebb1s@last.fm', 'k4DF55hX', '55-(279)283-5278', 'vel.gif', '1985-08-23', 1, 'Porto');
INSERT INTO user_table VALUES (66, 'Gerald Ray', 'gray1t', 'gray1t@delicious.com', 'J2HMVk', '62-(507)285-0729', 'iaculis diam erat.gif', '1986-08-19', 1, 'Porto');
INSERT INTO user_table VALUES (67, 'Angela Moore', 'amoore1u', 'amoore1u@icio.us', 'dA9VUbbgE', '7-(886)557-6489', 'ut suscipit.jpeg', '1991-07-04', 1, 'Porto');
INSERT INTO user_table VALUES (68, 'Nicholas Rice', 'nrice1v', 'nrice1v@artisteer.com', 'ySpabm', '62-(118)234-2746', 'integer ac.jpeg', '1988-03-25', 1, 'Porto');
INSERT INTO user_table VALUES (69, 'Lois Gilbert', 'lgilbert1w', 'lgilbert1w@hud.gov', 'LzNWXjGCR1I', '7-(534)366-4803', 'metus vitae.jpeg', '1991-10-24', 1, 'Porto');
INSERT INTO user_table VALUES (70, 'Stephen Stephens', 'sstephens1x', 'sstephens1x@ask.com', 'SeEG3ZY', '55-(639)162-7686', 'adipiscing elit proin.gif', '1988-04-26', 1, 'Porto');
INSERT INTO user_table VALUES (71, 'Ernest Matthews', 'ematthews1y', 'ematthews1y@dmoz.org', 'PE8rYDB0u', '1-(337)506-1080', 'at.jpeg', '1992-11-15', 1, 'Porto');
INSERT INTO user_table VALUES (72, 'Donna Bryant', 'dbryant1z', 'dbryant1z@bluehost.com', 'dRo5cFn2459c', '63-(907)820-5141', 'ipsum primis.jpeg', '1987-04-19', 1, 'Porto');
INSERT INTO user_table VALUES (73, 'Stephen Edwards', 'sedwards20', 'sedwards20@wiley.com', 'Msi5gzIDGdML', '226-(849)166-0203', 'pede ullamcorper augue.tiff', '1973-09-09', 1, 'Porto');
INSERT INTO user_table VALUES (74, 'Christopher Welch', 'cwelch21', 'cwelch21@oakley.com', 'EzkUXUjTRi7', '33-(689)971-6545', 'nullam porttitor.gif', '1977-09-23', 1, 'Porto');
INSERT INTO user_table VALUES (75, 'Patrick Allen', 'pallen22', 'pallen22@joomla.org', 'sNTgrTOt23Ma', '7-(520)341-4409', 'tortor eu.tiff', '1985-10-24', 1, 'Porto');
INSERT INTO user_table VALUES (4, 'Jessica Perez', 'jperez3', 'jperez3@blogtalkradio.com', 'eXxs97', '62-(598)990-6256', 'auctor.jpeg', '1999-01-23', 1, 'Porto');
INSERT INTO user_table VALUES (5, 'Shirley Reyes', 'sreyes4', 'sreyes4@ask.com', '5Rlb9YSf', '86-(747)101-8307', 'urna pretium.png', '1997-05-31', 1, 'Porto');
INSERT INTO user_table VALUES (6, 'Kathleen Young', 'kyoung5', 'kyoung5@wordpress.org', 'joV9hJoc', '234-(136)126-8687', 'non.tiff', '1997-08-18', 1, 'Porto');
INSERT INTO user_table VALUES (7, 'Melissa Elliott', 'melliott6', 'melliott6@drupal.org', 'XExsgcW', '44-(712)190-2037', 'risus.jpeg', '1974-09-09', 1, 'Porto');
INSERT INTO user_table VALUES (8, 'Antonio Robertson', 'arobertson7', 'arobertson7@usa.gov', '8Ibpxns', '7-(519)437-4622', 'cubilia curae nulla.jpeg', '1984-10-23', 1, 'Porto');
INSERT INTO user_table VALUES (9, 'William Long', 'wlong8', 'wlong8@elegantthemes.com', 'QkfHEpIy8k2', '39-(605)394-4017', 'cum sociis.gif', '1983-10-10', 1, 'Porto');
INSERT INTO user_table VALUES (10, 'Larry Davis', 'ldavis9', 'ldavis9@umich.edu', 'l2dsXUx0WWOn', '48-(687)895-4116', 'nulla tellus.jpeg', '1990-11-23', 1, 'Porto');
INSERT INTO user_table VALUES (11, 'Diana Mason', 'dmasona', 'dmasona@dot.gov', 'BsxGlxR', '359-(931)120-2457', 'cursus vestibulum proin.gif', '1974-11-18', 1, 'Porto');
INSERT INTO user_table VALUES (12, 'Paula Evans', 'pevansb', 'pevansb@army.mil', 'Sq3ItYs', '62-(984)359-7122', 'sem.tiff', '1979-10-28', 1, 'Porto');
INSERT INTO user_table VALUES (13, 'Gregory Hamilton', 'ghamiltonc', 'ghamiltonc@ezinearticles.com', 'Hj98GX', '57-(511)438-9802', 'odio odio elementum.png', '1979-03-21', 1, 'Porto');
INSERT INTO user_table VALUES (14, 'Christopher Kim', 'ckimd', 'ckimd@google.nl', 'Y9szCYOAVP4', '98-(331)384-5067', 'nulla eget eros.gif', '1971-05-26', 1, 'Porto');
INSERT INTO user_table VALUES (15, 'Frank Watson', 'fwatsone', 'fwatsone@youtube.com', 'Gouqa4zcp8', '351-(872)119-2493', 'convallis morbi.gif', '1984-09-25', 1, 'Porto');
INSERT INTO user_table VALUES (16, 'Keith Morris', 'kmorrisf', 'kmorrisf@goo.ne.jp', '1q0k96PCN', '420-(389)227-1693', 'neque.tiff', '1988-03-01', 1, 'Porto');
INSERT INTO user_table VALUES (17, 'Jacqueline Dixon', 'jdixong', 'jdixong@theguardian.com', 'H9ZirvRS8', '62-(323)137-2865', 'tortor.jpeg', '1990-10-18', 1, 'Porto');
INSERT INTO user_table VALUES (18, 'Deborah Bradley', 'dbradleyh', 'dbradleyh@telegraph.co.uk', 'xhbK7VG', '62-(348)300-6120', 'cum.tiff', '1985-04-17', 1, 'Porto');
INSERT INTO user_table VALUES (19, 'Timothy Davis', 'tdavisi', 'tdavisi@nasa.gov', 'hEenCq3U2Mc3', '62-(966)764-2438', 'sapien.tiff', '1972-03-26', 1, 'Porto');
INSERT INTO user_table VALUES (20, 'Wayne Bryant', 'wbryantj', 'wbryantj@desdev.cn', 'S6G20T', '86-(701)590-2425', 'odio in hac.jpeg', '1990-12-21', 1, 'Porto');
INSERT INTO user_table VALUES (61, 'Janet Reynolds', 'jreynolds1o', 'jreynolds1o@house.gov', '3NDXNu', '380-(288)852-5244', 'neque duis.png', '1999-06-28', 1, 'Porto');
INSERT INTO user_table VALUES (76, 'Judith Carpenter', 'jcarpenter23', 'jcarpenter23@quantcast.com', 'pICRxEfb7T', '55-(770)100-1137', 'pede malesuada.jpeg', '1974-02-20', 1, 'Porto');
INSERT INTO user_table VALUES (77, 'Amy Coleman', 'acoleman24', 'acoleman24@hao123.com', 'WnYEXmb091', '31-(165)848-0439', 'amet lobortis sapien.jpeg', '1994-09-27', 1, 'Porto');
INSERT INTO user_table VALUES (78, 'Adam Kim', 'akim25', 'akim25@google.com.br', '1H0INY3', '1-(168)615-9900', 'viverra.tiff', '1986-05-02', 1, 'Porto');
INSERT INTO user_table VALUES (79, 'Heather Green', 'hgreen26', 'hgreen26@google.pl', 'xXEoFGV', '86-(964)700-5280', 'nisi volutpat.jpeg', '1982-08-20', 1, 'Porto');
INSERT INTO user_table VALUES (80, 'Fred Jackson', 'fjackson27', 'fjackson27@state.gov', '7lUaZA5', '84-(956)157-6300', 'augue vestibulum.tiff', '1977-12-19', 1, 'Porto');
INSERT INTO user_table VALUES (81, 'Michael Hicks', 'mhicks28', 'mhicks28@google.cn', '5GmMkz7Xt0vU', '62-(876)857-0897', 'dictumst morbi vestibulum.jpeg', '1981-05-09', 1, 'Porto');
INSERT INTO user_table VALUES (82, 'Todd Rose', 'trose29', 'trose29@w3.org', 'VsxjNEH', '81-(197)146-6331', 'at nunc commodo.png', '1996-12-22', 1, 'Porto');
INSERT INTO user_table VALUES (83, 'Benjamin Wright', 'bwright2a', 'bwright2a@europa.eu', '5IQ2iVEqtdf7', '7-(885)176-4368', 'non pretium.jpeg', '1998-04-17', 1, 'Porto');
INSERT INTO user_table VALUES (84, 'Victor Lawrence', 'vlawrence2b', 'vlawrence2b@free.fr', 'GyKq2wCmfo', '351-(813)125-0547', 'id sapien.jpeg', '1971-06-20', 1, 'Porto');
INSERT INTO user_table VALUES (85, 'Lillian Harrison', 'lharrison2c', 'lharrison2c@tuttocitta.it', 'RNcdi32wS', '375-(979)623-0135', 'luctus rutrum nulla.gif', '1998-02-28', 1, 'Porto');
INSERT INTO user_table VALUES (86, 'Eugene Price', 'eprice2d', 'eprice2d@oakley.com', 'MN3efP5cGRA', '249-(205)181-4811', 'semper sapien.tiff', '1999-09-19', 1, 'Porto');
INSERT INTO user_table VALUES (87, 'Brian Stewart', 'bstewart2e', 'bstewart2e@purevolume.com', 'ewsSTDOKT', '62-(506)241-0088', 'interdum eu tincidunt.jpeg', '1999-07-05', 1, 'Porto');
INSERT INTO user_table VALUES (88, 'Benjamin Bell', 'bbell2f', 'bbell2f@home.pl', 'I1glLUAWP4', '92-(519)142-4714', 'ligula nec.tiff', '1977-06-30', 1, 'Porto');
INSERT INTO user_table VALUES (89, 'Craig Ford', 'cford2g', 'cford2g@ucsd.edu', 'oNGHph', '46-(499)613-5561', 'nulla.jpeg', '1987-05-08', 1, 'Porto');
INSERT INTO user_table VALUES (90, 'Debra Rodriguez', 'drodriguez2h', 'drodriguez2h@shareasale.com', '5BjqD6', '63-(368)407-2171', 'luctus.gif', '1990-12-09', 1, 'Porto');
INSERT INTO user_table VALUES (91, 'Steve Brown', 'sbrown2i', 'sbrown2i@jigsy.com', 'xKV49E', '375-(273)177-0390', 'ante.tiff', '1992-01-24', 1, 'Porto');
INSERT INTO user_table VALUES (92, 'Randy Spencer', 'rspencer2j', 'rspencer2j@drupal.org', 'FN64FXE', '98-(258)881-2018', 'donec pharetra.gif', '1985-12-09', 1, 'Porto');
INSERT INTO user_table VALUES (93, 'Louis Tucker', 'ltucker2k', 'ltucker2k@icio.us', 'TbFJEp', '62-(165)310-0575', 'sit.jpeg', '1978-11-13', 1, 'Porto');
INSERT INTO user_table VALUES (94, 'Julia Brown', 'jbrown2l', 'jbrown2l@github.io', 'qwlTjV', '7-(881)873-9921', 'vel dapibus at.jpeg', '1997-03-16', 1, 'Porto');
INSERT INTO user_table VALUES (95, 'Phyllis Reynolds', 'preynolds2m', 'preynolds2m@telegraph.co.uk', 't0LLCnC', '1-(735)521-3213', 'nullam varius nulla.gif', '1990-08-16', 1, 'Porto');
INSERT INTO user_table VALUES (96, 'Lois Frazier', 'lfrazier2n', 'lfrazier2n@unesco.org', 'MQeKuvB', '33-(555)918-5232', 'erat.jpeg', '1970-06-05', 1, 'Porto');
INSERT INTO user_table VALUES (97, 'Robert James', 'rjames2o', 'rjames2o@ovh.net', 'pX4QKNbknT6', '86-(823)441-7160', 'pretium.jpeg', '1999-10-17', 1, 'Porto');
INSERT INTO user_table VALUES (98, 'Craig Hill', 'chill2p', 'chill2p@ted.com', '9MAjUz', '62-(745)770-1646', 'molestie lorem quisque.jpeg', '1982-11-11', 1, 'Porto');
INSERT INTO user_table VALUES (99, 'Albert Weaver', 'aweaver2q', 'aweaver2q@freewebs.com', '9NBdeX', '20-(218)923-4307', 'ut.jpeg', '1993-09-09', 1, 'Porto');
INSERT INTO user_table VALUES (100, 'Jacqueline Oliver', 'joliver2r', 'joliver2r@china.com.cn', 'XrVdxrRYB', '86-(988)573-3521', 'consectetuer adipiscing.jpeg', '1985-09-21', 1, 'Porto');
INSERT INTO user_table VALUES (1, 'Julia Bailey', 'jbailey0', 'jbailey0@dagondesign.com', 'UfU2upu7Vz', '55-(320)597-3600', 'lacinia.gif', '1993-12-08', 1, 'Porto');


--
-- Name: Task_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1614; Tablespace: 
--

ALTER TABLE ONLY task
    ADD CONSTRAINT "Task_pkey" PRIMARY KEY (id);


--
-- Name: User_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1614; Tablespace: 
--

ALTER TABLE ONLY user_table
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: comment_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1614; Tablespace: 
--

ALTER TABLE ONLY comment
    ADD CONSTRAINT comment_pkey PRIMARY KEY (id);


--
-- Name: country_name_key; Type: CONSTRAINT; Schema: public; Owner: lbaw1614; Tablespace: 
--

ALTER TABLE ONLY country
    ADD CONSTRAINT country_name_key UNIQUE (name);


--
-- Name: country_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1614; Tablespace: 
--

ALTER TABLE ONLY country
    ADD CONSTRAINT country_pkey PRIMARY KEY (id);


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
-- Name: user_table_email_key; Type: CONSTRAINT; Schema: public; Owner: lbaw1614; Tablespace: 
--

ALTER TABLE ONLY user_table
    ADD CONSTRAINT user_table_email_key UNIQUE (email);


--
-- Name: checkNewForumPostDate; Type: TRIGGER; Schema: public; Owner: lbaw1614
--

CREATE TRIGGER "checkNewForumPostDate" BEFORE INSERT OR UPDATE ON forum_post FOR EACH ROW EXECUTE PROCEDURE "noModificationAfterCreation"();


--
-- Name: onChangeMeetingToPast; Type: TRIGGER; Schema: public; Owner: lbaw1614
--

CREATE TRIGGER "onChangeMeetingToPast" BEFORE INSERT OR UPDATE ON meeting FOR EACH ROW EXECUTE PROCEDURE "noPastMeetings"();


--
-- Name: onCreateMeeting; Type: TRIGGER; Schema: public; Owner: lbaw1614
--

CREATE TRIGGER "onCreateMeeting" AFTER INSERT ON meeting FOR EACH ROW EXECUTE PROCEDURE "insertUserMeeting"();


--
-- Name: onFutureBirth; Type: TRIGGER; Schema: public; Owner: lbaw1614
--

CREATE TRIGGER "onFutureBirth" BEFORE INSERT OR UPDATE ON user_table FOR EACH ROW EXECUTE PROCEDURE "noFutureBirth"();


--
-- Name: onFutureComment; Type: TRIGGER; Schema: public; Owner: lbaw1614
--

CREATE TRIGGER "onFutureComment" BEFORE INSERT OR UPDATE ON comment FOR EACH ROW EXECUTE PROCEDURE "noFutureCreationDate"();


--
-- Name: onFutureReply; Type: TRIGGER; Schema: public; Owner: lbaw1614
--

CREATE TRIGGER "onFutureReply" BEFORE INSERT OR UPDATE ON forum_reply FOR EACH ROW EXECUTE PROCEDURE "noFutureCreationDate"();


--
-- Name: onInsertRepeatedUser; Type: TRIGGER; Schema: public; Owner: lbaw1614
--

CREATE TRIGGER "onInsertRepeatedUser" BEFORE INSERT OR UPDATE ON user_meeting FOR EACH ROW EXECUTE PROCEDURE "insertRepeatedMeetingInvite"();


--
-- Name: onReplyBeforePost; Type: TRIGGER; Schema: public; Owner: lbaw1614
--

CREATE TRIGGER "onReplyBeforePost" BEFORE INSERT OR UPDATE ON forum_reply FOR EACH ROW EXECUTE PROCEDURE "noReplyBeforePost"();


--
-- Name: onUpdateFutureFile; Type: TRIGGER; Schema: public; Owner: lbaw1614
--

CREATE TRIGGER "onUpdateFutureFile" BEFORE INSERT OR UPDATE ON file FOR EACH ROW EXECUTE PROCEDURE "noFutureUploads"();


--
-- Name: updateForumPostDateModification; Type: TRIGGER; Schema: public; Owner: lbaw1614
--

CREATE TRIGGER "updateForumPostDateModification" BEFORE INSERT ON forum_reply FOR EACH ROW EXECUTE PROCEDURE "updateDateModified"();


--
-- Name: Project-User_id-project_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY user_project
    ADD CONSTRAINT "Project-User_id-project_fkey" FOREIGN KEY (id_project) REFERENCES project(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Task_assigned-id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY task
    ADD CONSTRAINT "Task_assigned-id_fkey" FOREIGN KEY (assigned_id) REFERENCES user_table(id);


--
-- Name: Task_completer-id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY task
    ADD CONSTRAINT "Task_completer-id_fkey" FOREIGN KEY (completer_id) REFERENCES user_table(id);


--
-- Name: Task_creator-id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY task
    ADD CONSTRAINT "Task_creator-id_fkey" FOREIGN KEY (creator_id) REFERENCES user_table(id);


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
    ADD CONSTRAINT "comment-like_id_user_fkey" FOREIGN KEY (id_user) REFERENCES user_table(id);


--
-- Name: comment_id-task_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY comment
    ADD CONSTRAINT "comment_id-task_fkey" FOREIGN KEY (id_task) REFERENCES task(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: comment_id-user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY comment
    ADD CONSTRAINT "comment_id-user_fkey" FOREIGN KEY (id_user) REFERENCES user_table(id);


--
-- Name: file_meeting_file_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY file_meeting
    ADD CONSTRAINT file_meeting_file_id_fkey FOREIGN KEY (file_id) REFERENCES file(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: file_meeting_meeting_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY file_meeting
    ADD CONSTRAINT file_meeting_meeting_id_fkey FOREIGN KEY (meeting_id) REFERENCES meeting(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: file_project-id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY file
    ADD CONSTRAINT "file_project-id_fkey" FOREIGN KEY (project_id) REFERENCES project(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: file_tag_id_file_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY file_tag
    ADD CONSTRAINT file_tag_id_file_fkey FOREIGN KEY (file_id) REFERENCES file(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: file_tag_id_tag_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY file_tag
    ADD CONSTRAINT file_tag_id_tag_fkey FOREIGN KEY (tag_id) REFERENCES tag(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: file_uploader-id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY file
    ADD CONSTRAINT "file_uploader-id_fkey" FOREIGN KEY (uploader_id) REFERENCES user_table(id);


--
-- Name: forum_post_id_creator_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY forum_post
    ADD CONSTRAINT forum_post_id_creator_fkey FOREIGN KEY (id_creator) REFERENCES user_table(id) ON UPDATE CASCADE;


--
-- Name: forum_post_id_project_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY forum_post
    ADD CONSTRAINT forum_post_id_project_fkey FOREIGN KEY (id_project) REFERENCES project(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: forum_post_like_id_post_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY forum_post_like
    ADD CONSTRAINT forum_post_like_id_post_fkey FOREIGN KEY (id_post) REFERENCES forum_post(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: forum_post_like_id_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY forum_post_like
    ADD CONSTRAINT forum_post_like_id_user_fkey FOREIGN KEY (id_user) REFERENCES user_table(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: forum_reply_id_creator_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY forum_reply
    ADD CONSTRAINT forum_reply_id_creator_fkey FOREIGN KEY (creator_id) REFERENCES user_table(id) ON UPDATE CASCADE;


--
-- Name: forum_reply_like_reply_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY forum_reply_like
    ADD CONSTRAINT forum_reply_like_reply_id_fkey FOREIGN KEY (reply_id) REFERENCES comment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: forum_reply_like_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY forum_reply_like
    ADD CONSTRAINT forum_reply_like_user_id_fkey FOREIGN KEY (user_id) REFERENCES user_table(id);


--
-- Name: forum_reply_post-id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY forum_reply
    ADD CONSTRAINT "forum_reply_post-id_fkey" FOREIGN KEY (post_id) REFERENCES forum_post(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: meeting_id-creator_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY meeting
    ADD CONSTRAINT "meeting_id-creator_fkey" FOREIGN KEY (id_creator) REFERENCES user_table(id);


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
    ADD CONSTRAINT user_id FOREIGN KEY (id_user) REFERENCES user_table(id);


--
-- Name: user_meeting_meeting-id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY user_meeting
    ADD CONSTRAINT "user_meeting_meeting-id_fkey" FOREIGN KEY (meeting_id) REFERENCES meeting(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_meeting_user-id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY user_meeting
    ADD CONSTRAINT "user_meeting_user-id_fkey" FOREIGN KEY (user_id) REFERENCES user_table(id);


--
-- Name: user_table_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1614
--

ALTER TABLE ONLY user_table
    ADD CONSTRAINT user_table_country_id_fkey FOREIGN KEY (country_id) REFERENCES country(id) ON UPDATE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: lbaw1614
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM lbaw1614;
GRANT ALL ON SCHEMA public TO lbaw1614;


--
-- PostgreSQL database dump complete
--

