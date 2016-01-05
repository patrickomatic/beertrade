--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: update_feedback_count(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_feedback_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
          IF (TG_OP = 'UPDATE' OR TG_OP = 'INSERT') THEN
            IF (TG_OP = 'UPDATE' AND (OLD.feedback_approved_at IS NOT NULL AND OLD.feedback_type IS NULL)) THEN
              RETURN FALSE;
            END IF;

            -- We should only update if feedback_type and feedback_approved_at
            -- was never previously set and that both values are properly set
            -- on update.
            IF (NEW.feedback_approved_at IS NOT NULL AND NEW.feedback_type IS NOT NULL) THEN
              -- feedback_type: 0 = negative, 1 = neutral, 2 = positive
              CASE NEW.feedback_type
                WHEN 0 THEN
                  UPDATE users SET "negative_feedback_count" = "negative_feedback_count" + 1 WHERE id = NEW.user_id;
                WHEN 1 THEN
                  UPDATE users SET "neutral_feedback_count" = "neutral_feedback_count" + 1 WHERE id = NEW.user_id;
                WHEN 2 THEN
                  UPDATE users SET "positive_feedback_count" = "positive_feedback_count" + 1 WHERE id = NEW.user_id;
                ELSE
                  RAISE NOTICE 'feedback_type unknown';
              END CASE;
            END IF;
          END IF;

          RETURN NEW;
        END;
        $$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notifications (
    id integer NOT NULL,
    user_id integer NOT NULL,
    trade_id integer NOT NULL,
    message text NOT NULL,
    seen_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    hashcode text NOT NULL
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notifications_id_seq OWNED BY notifications.id;


--
-- Name: participants; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE participants (
    id integer NOT NULL,
    user_id integer NOT NULL,
    trade_id integer NOT NULL,
    shipping_info text,
    feedback text,
    feedback_type integer,
    accepted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    feedback_approved_at timestamp without time zone
);


--
-- Name: participants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE participants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: participants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE participants_id_seq OWNED BY participants.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: trades; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trades (
    id integer NOT NULL,
    agreement text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    completed_at timestamp without time zone
);


--
-- Name: trades_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE trades_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: trades_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE trades_id_seq OWNED BY trades.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    username text NOT NULL,
    auth_uid character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    moderator boolean DEFAULT false,
    positive_feedback_count integer DEFAULT 0 NOT NULL,
    neutral_feedback_count integer DEFAULT 0 NOT NULL,
    negative_feedback_count integer DEFAULT 0 NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications ALTER COLUMN id SET DEFAULT nextval('notifications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY participants ALTER COLUMN id SET DEFAULT nextval('participants_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY trades ALTER COLUMN id SET DEFAULT nextval('trades_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: participants_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY participants
    ADD CONSTRAINT participants_pkey PRIMARY KEY (id);


--
-- Name: trades_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY trades
    ADD CONSTRAINT trades_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_participants_on_trade_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_participants_on_trade_id ON participants USING btree (trade_id);


--
-- Name: index_participants_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_participants_on_user_id ON participants USING btree (user_id);


--
-- Name: index_users_on_auth_uid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_auth_uid ON users USING btree (auth_uid);


--
-- Name: index_users_on_lower_username; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_lower_username ON users USING btree (lower(username));


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: update_feedback_count; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_feedback_count AFTER INSERT OR UPDATE ON participants FOR EACH ROW EXECUTE PROCEDURE update_feedback_count();


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20150807013545');

INSERT INTO schema_migrations (version) VALUES ('20150813013543');

INSERT INTO schema_migrations (version) VALUES ('20150826215025');

INSERT INTO schema_migrations (version) VALUES ('20150911010956');

INSERT INTO schema_migrations (version) VALUES ('20150913173256');

INSERT INTO schema_migrations (version) VALUES ('20150921224909');

INSERT INTO schema_migrations (version) VALUES ('20150929221618');

INSERT INTO schema_migrations (version) VALUES ('20150929230040');

INSERT INTO schema_migrations (version) VALUES ('20151024204508');

INSERT INTO schema_migrations (version) VALUES ('20151027171552');

INSERT INTO schema_migrations (version) VALUES ('20160104214440');

INSERT INTO schema_migrations (version) VALUES ('20160104214502');

