--
-- PostgreSQL database dump
--

-- Dumped from database version 12.8
-- Dumped by pg_dump version 12.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: queries_search_vector_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.queries_search_vector_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
            BEGIN
                NEW.search_vector = ((setweight(to_tsvector('pg_catalog.simple', regexp_replace(coalesce(CAST(NEW.id AS TEXT), ''), '[-@.]', ' ', 'g')), 'B') || setweight(to_tsvector('pg_catalog.simple', regexp_replace(coalesce(NEW.name, ''), '[-@.]', ' ', 'g')), 'A')) || setweight(to_tsvector('pg_catalog.simple', regexp_replace(coalesce(NEW.description, ''), '[-@.]', ' ', 'g')), 'C')) || setweight(to_tsvector('pg_catalog.simple', regexp_replace(coalesce(NEW.query, ''), '[-@.]', ' ', 'g')), 'D');
                RETURN NEW;
            END
            $$;


ALTER FUNCTION public.queries_search_vector_update() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: access_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.access_permissions (
    object_type character varying(255) NOT NULL,
    object_id integer NOT NULL,
    id integer NOT NULL,
    access_type character varying(255) NOT NULL,
    grantor_id integer NOT NULL,
    grantee_id integer NOT NULL
);


ALTER TABLE public.access_permissions OWNER TO postgres;

--
-- Name: access_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.access_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.access_permissions_id_seq OWNER TO postgres;

--
-- Name: access_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.access_permissions_id_seq OWNED BY public.access_permissions.id;


--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO postgres;

--
-- Name: alert_subscriptions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alert_subscriptions (
    updated_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    id integer NOT NULL,
    user_id integer NOT NULL,
    destination_id integer,
    alert_id integer NOT NULL
);


ALTER TABLE public.alert_subscriptions OWNER TO postgres;

--
-- Name: alert_subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.alert_subscriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.alert_subscriptions_id_seq OWNER TO postgres;

--
-- Name: alert_subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.alert_subscriptions_id_seq OWNED BY public.alert_subscriptions.id;


--
-- Name: alerts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alerts (
    updated_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    query_id integer NOT NULL,
    user_id integer NOT NULL,
    options text NOT NULL,
    state character varying(255) NOT NULL,
    last_triggered_at timestamp with time zone,
    rearm integer
);


ALTER TABLE public.alerts OWNER TO postgres;

--
-- Name: alerts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.alerts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.alerts_id_seq OWNER TO postgres;

--
-- Name: alerts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.alerts_id_seq OWNED BY public.alerts.id;


--
-- Name: api_keys; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.api_keys (
    object_type character varying(255) NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    id integer NOT NULL,
    org_id integer NOT NULL,
    api_key character varying(255) NOT NULL,
    active boolean NOT NULL,
    object_id integer NOT NULL,
    created_by_id integer
);


ALTER TABLE public.api_keys OWNER TO postgres;

--
-- Name: api_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.api_keys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.api_keys_id_seq OWNER TO postgres;

--
-- Name: api_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.api_keys_id_seq OWNED BY public.api_keys.id;


--
-- Name: changes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.changes (
    object_type character varying(255) NOT NULL,
    id integer NOT NULL,
    object_id integer NOT NULL,
    object_version integer NOT NULL,
    user_id integer NOT NULL,
    change text NOT NULL,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.changes OWNER TO postgres;

--
-- Name: changes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.changes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.changes_id_seq OWNER TO postgres;

--
-- Name: changes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.changes_id_seq OWNED BY public.changes.id;


--
-- Name: dashboards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dashboards (
    updated_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    id integer NOT NULL,
    version integer NOT NULL,
    org_id integer NOT NULL,
    slug character varying(140) NOT NULL,
    name character varying(100) NOT NULL,
    user_id integer NOT NULL,
    layout text NOT NULL,
    dashboard_filters_enabled boolean NOT NULL,
    is_archived boolean NOT NULL,
    is_draft boolean NOT NULL,
    tags character varying[],
    options json DEFAULT '{}'::json NOT NULL
);


ALTER TABLE public.dashboards OWNER TO postgres;

--
-- Name: dashboards_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dashboards_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dashboards_id_seq OWNER TO postgres;

--
-- Name: dashboards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dashboards_id_seq OWNED BY public.dashboards.id;


--
-- Name: data_source_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.data_source_groups (
    id integer NOT NULL,
    data_source_id integer NOT NULL,
    group_id integer NOT NULL,
    view_only boolean NOT NULL
);


ALTER TABLE public.data_source_groups OWNER TO postgres;

--
-- Name: data_source_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.data_source_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.data_source_groups_id_seq OWNER TO postgres;

--
-- Name: data_source_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.data_source_groups_id_seq OWNED BY public.data_source_groups.id;


--
-- Name: data_sources; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.data_sources (
    id integer NOT NULL,
    org_id integer NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    encrypted_options bytea NOT NULL,
    queue_name character varying(255) NOT NULL,
    scheduled_queue_name character varying(255) NOT NULL,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.data_sources OWNER TO postgres;

--
-- Name: data_sources_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.data_sources_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.data_sources_id_seq OWNER TO postgres;

--
-- Name: data_sources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.data_sources_id_seq OWNED BY public.data_sources.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events (
    id integer NOT NULL,
    org_id integer NOT NULL,
    user_id integer,
    action character varying(255) NOT NULL,
    object_type character varying(255) NOT NULL,
    object_id character varying(255),
    additional_properties text,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.events OWNER TO postgres;

--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_id_seq OWNER TO postgres;

--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: favorites; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.favorites (
    updated_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    id integer NOT NULL,
    org_id integer NOT NULL,
    object_type character varying(255) NOT NULL,
    object_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.favorites OWNER TO postgres;

--
-- Name: favorites_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.favorites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.favorites_id_seq OWNER TO postgres;

--
-- Name: favorites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.favorites_id_seq OWNED BY public.favorites.id;


--
-- Name: groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.groups (
    id integer NOT NULL,
    org_id integer NOT NULL,
    type character varying(255) NOT NULL,
    name character varying(100) NOT NULL,
    permissions character varying(255)[] NOT NULL,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.groups OWNER TO postgres;

--
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.groups_id_seq OWNER TO postgres;

--
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.groups_id_seq OWNED BY public.groups.id;


--
-- Name: notification_destinations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification_destinations (
    id integer NOT NULL,
    org_id integer NOT NULL,
    user_id integer NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    encrypted_options bytea NOT NULL,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.notification_destinations OWNER TO postgres;

--
-- Name: notification_destinations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notification_destinations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notification_destinations_id_seq OWNER TO postgres;

--
-- Name: notification_destinations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notification_destinations_id_seq OWNED BY public.notification_destinations.id;


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organizations (
    updated_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    settings text NOT NULL
);


ALTER TABLE public.organizations OWNER TO postgres;

--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.organizations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.organizations_id_seq OWNER TO postgres;

--
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.organizations_id_seq OWNED BY public.organizations.id;


--
-- Name: queries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.queries (
    updated_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    id integer NOT NULL,
    version integer NOT NULL,
    org_id integer NOT NULL,
    data_source_id integer,
    latest_query_data_id integer,
    name character varying(255) NOT NULL,
    description character varying(4096),
    query text NOT NULL,
    query_hash character varying(32) NOT NULL,
    api_key character varying(40) NOT NULL,
    user_id integer NOT NULL,
    last_modified_by_id integer,
    is_archived boolean NOT NULL,
    is_draft boolean NOT NULL,
    schedule text,
    schedule_failures integer NOT NULL,
    options text NOT NULL,
    search_vector tsvector,
    tags character varying[]
);


ALTER TABLE public.queries OWNER TO postgres;

--
-- Name: queries_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.queries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.queries_id_seq OWNER TO postgres;

--
-- Name: queries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.queries_id_seq OWNED BY public.queries.id;


--
-- Name: query_results; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.query_results (
    id integer NOT NULL,
    org_id integer NOT NULL,
    data_source_id integer NOT NULL,
    query_hash character varying(32) NOT NULL,
    query text NOT NULL,
    data text NOT NULL,
    runtime double precision NOT NULL,
    retrieved_at timestamp with time zone NOT NULL
);


ALTER TABLE public.query_results OWNER TO postgres;

--
-- Name: query_results_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.query_results_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.query_results_id_seq OWNER TO postgres;

--
-- Name: query_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.query_results_id_seq OWNED BY public.query_results.id;


--
-- Name: query_snippets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.query_snippets (
    updated_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    id integer NOT NULL,
    org_id integer NOT NULL,
    trigger character varying(255) NOT NULL,
    description text NOT NULL,
    user_id integer NOT NULL,
    snippet text NOT NULL
);


ALTER TABLE public.query_snippets OWNER TO postgres;

--
-- Name: query_snippets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.query_snippets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.query_snippets_id_seq OWNER TO postgres;

--
-- Name: query_snippets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.query_snippets_id_seq OWNED BY public.query_snippets.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    updated_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    id integer NOT NULL,
    org_id integer NOT NULL,
    name character varying(320) NOT NULL,
    email character varying(255) NOT NULL,
    profile_image_url character varying(320),
    password_hash character varying(128),
    groups integer[],
    api_key character varying(40) NOT NULL,
    disabled_at timestamp with time zone,
    details json DEFAULT '{}'::json
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: visualizations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.visualizations (
    updated_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    id integer NOT NULL,
    type character varying(100) NOT NULL,
    query_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4096),
    options text NOT NULL
);


ALTER TABLE public.visualizations OWNER TO postgres;

--
-- Name: visualizations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.visualizations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.visualizations_id_seq OWNER TO postgres;

--
-- Name: visualizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.visualizations_id_seq OWNED BY public.visualizations.id;


--
-- Name: widgets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.widgets (
    updated_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    id integer NOT NULL,
    visualization_id integer,
    text text,
    width integer NOT NULL,
    options text NOT NULL,
    dashboard_id integer NOT NULL
);


ALTER TABLE public.widgets OWNER TO postgres;

--
-- Name: widgets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.widgets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.widgets_id_seq OWNER TO postgres;

--
-- Name: widgets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.widgets_id_seq OWNED BY public.widgets.id;


--
-- Name: access_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.access_permissions ALTER COLUMN id SET DEFAULT nextval('public.access_permissions_id_seq'::regclass);


--
-- Name: alert_subscriptions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alert_subscriptions ALTER COLUMN id SET DEFAULT nextval('public.alert_subscriptions_id_seq'::regclass);


--
-- Name: alerts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerts ALTER COLUMN id SET DEFAULT nextval('public.alerts_id_seq'::regclass);


--
-- Name: api_keys id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.api_keys ALTER COLUMN id SET DEFAULT nextval('public.api_keys_id_seq'::regclass);


--
-- Name: changes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.changes ALTER COLUMN id SET DEFAULT nextval('public.changes_id_seq'::regclass);


--
-- Name: dashboards id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboards ALTER COLUMN id SET DEFAULT nextval('public.dashboards_id_seq'::regclass);


--
-- Name: data_source_groups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_source_groups ALTER COLUMN id SET DEFAULT nextval('public.data_source_groups_id_seq'::regclass);


--
-- Name: data_sources id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_sources ALTER COLUMN id SET DEFAULT nextval('public.data_sources_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: favorites id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorites ALTER COLUMN id SET DEFAULT nextval('public.favorites_id_seq'::regclass);


--
-- Name: groups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups ALTER COLUMN id SET DEFAULT nextval('public.groups_id_seq'::regclass);


--
-- Name: notification_destinations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_destinations ALTER COLUMN id SET DEFAULT nextval('public.notification_destinations_id_seq'::regclass);


--
-- Name: organizations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizations ALTER COLUMN id SET DEFAULT nextval('public.organizations_id_seq'::regclass);


--
-- Name: queries id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.queries ALTER COLUMN id SET DEFAULT nextval('public.queries_id_seq'::regclass);


--
-- Name: query_results id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.query_results ALTER COLUMN id SET DEFAULT nextval('public.query_results_id_seq'::regclass);


--
-- Name: query_snippets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.query_snippets ALTER COLUMN id SET DEFAULT nextval('public.query_snippets_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: visualizations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visualizations ALTER COLUMN id SET DEFAULT nextval('public.visualizations_id_seq'::regclass);


--
-- Name: widgets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.widgets ALTER COLUMN id SET DEFAULT nextval('public.widgets_id_seq'::regclass);


--
-- Data for Name: access_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.access_permissions (object_type, object_id, id, access_type, grantor_id, grantee_id) FROM stdin;
\.


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alembic_version (version_num) FROM stdin;
89bc7873a3e0
\.


--
-- Data for Name: alert_subscriptions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alert_subscriptions (updated_at, created_at, id, user_id, destination_id, alert_id) FROM stdin;
\.


--
-- Data for Name: alerts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alerts (updated_at, created_at, id, name, query_id, user_id, options, state, last_triggered_at, rearm) FROM stdin;
\.


--
-- Data for Name: api_keys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.api_keys (object_type, updated_at, created_at, id, org_id, api_key, active, object_id, created_by_id) FROM stdin;
\.


--
-- Data for Name: changes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.changes (object_type, id, object_id, object_version, user_id, change, created_at) FROM stdin;
\.


--
-- Data for Name: dashboards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dashboards (updated_at, created_at, id, version, org_id, slug, name, user_id, layout, dashboard_filters_enabled, is_archived, is_draft, tags, options) FROM stdin;
\.


--
-- Data for Name: data_source_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.data_source_groups (id, data_source_id, group_id, view_only) FROM stdin;
1	1	2	f
2	2	2	f
\.


--
-- Data for Name: data_sources; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.data_sources (id, org_id, name, type, encrypted_options, queue_name, scheduled_queue_name, created_at) FROM stdin;
1	1	MySQL	mysql	\\x6741414141414268676f71736931697a467554566f6d556f463750323644694d786831703171774e4c2d63354556634e4467516e4e7239436762312d7950576a4232625163696961586c34524a6f7847654f39795f66336439335f6b726434536c4d675470436163533568506870486d513733597868775450686571583457564e623970544f34387076514844695f6831555a4469657a334c654832595954342d773d3d	queries	scheduled_queries	2021-11-03 13:12:05.870499+00
2	1	metadata	pg	\\x6741414141414268676f724b77504c6b30384d636a3230555952337247324f32666f4441694b32785a4f4d657172462d4a61527379307032657a50347556596e5868544b43484432514868716e6e674b324e6e413870566c577a6c4d543834675135467541456c5a684753586a6b7042506436694d75587a5432785f466f46504259526466325037505f3669315466616e6b5f716950517078356e5f784a6b32364275653779375a73456c3133446d69744946364331593d	queries	scheduled_queries	2021-11-03 13:12:39.7361+00
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events (id, org_id, user_id, action, object_type, object_id, additional_properties, created_at) FROM stdin;
1	1	1	login	redash	\N	{"user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36", "ip": "192.168.192.1"}	2021-11-03 13:11:48+00
2	1	1	load_favorites	dashboard	\N	{"params": {"q": null, "tags": [], "page": 1}, "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36", "ip": "192.168.192.1"}	2021-11-03 13:11:49+00
3	1	1	load_favorites	query	\N	{"params": {"q": null, "tags": [], "page": 1}, "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36", "ip": "192.168.192.1"}	2021-11-03 13:11:49+00
4	1	1	view	page	personal_homepage	{"screen_resolution": "1920x1080", "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36", "ip": "192.168.192.1"}	2021-11-03 13:11:49.54+00
5	1	1	list	datasource	admin/data_sources	{"user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36", "ip": "192.168.192.1"}	2021-11-03 13:11:51+00
6	1	1	view	page	data_sources/new	{"screen_resolution": "1920x1080", "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36", "ip": "192.168.192.1"}	2021-11-03 13:11:52.139+00
7	1	1	create	datasource	1	{"user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36", "ip": "192.168.192.1"}	2021-11-03 13:12:05+00
8	1	1	list	datasource	admin/data_sources	{"user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36", "ip": "192.168.192.1"}	2021-11-03 13:12:05+00
9	1	1	view	datasource	1	{"user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36", "ip": "192.168.192.1"}	2021-11-03 13:12:06+00
10	1	1	test	datasource	1	{"result": {"message": "success", "ok": true}, "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36", "ip": "192.168.192.1"}	2021-11-03 13:12:09+00
11	1	1	edit	datasource	1	{"user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36", "ip": "192.168.192.1"}	2021-11-03 13:12:12+00
12	1	1	list	datasource	admin/data_sources	{"user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36", "ip": "192.168.192.1"}	2021-11-03 13:12:20+00
13	1	1	view	page	data_sources/new	{"screen_resolution": "1920x1080", "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36", "ip": "192.168.192.1"}	2021-11-03 13:12:21.647+00
14	1	1	create	datasource	2	{"user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36", "ip": "192.168.192.1"}	2021-11-03 13:12:39+00
15	1	1	list	datasource	admin/data_sources	{"user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36", "ip": "192.168.192.1"}	2021-11-03 13:12:39+00
16	1	1	view	datasource	2	{"user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36", "ip": "192.168.192.1"}	2021-11-03 13:12:39+00
17	1	1	test	datasource	2	{"result": {"message": "success", "ok": true}, "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36", "ip": "192.168.192.1"}	2021-11-03 13:12:41+00
18	1	1	edit	datasource	2	{"user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36", "ip": "192.168.192.1"}	2021-11-03 13:12:42+00
\.


--
-- Data for Name: favorites; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.favorites (updated_at, created_at, id, org_id, object_type, object_id, user_id) FROM stdin;
\.


--
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.groups (id, org_id, type, name, permissions, created_at) FROM stdin;
1	1	builtin	admin	{admin,super_admin}	2021-11-03 13:11:48.280357+00
2	1	builtin	default	{create_dashboard,create_query,edit_dashboard,edit_query,view_query,view_source,execute_query,list_users,schedule_query,list_dashboards,list_alerts,list_data_sources}	2021-11-03 13:11:48.280357+00
\.


--
-- Data for Name: notification_destinations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification_destinations (id, org_id, user_id, name, type, encrypted_options, created_at) FROM stdin;
\.


--
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organizations (updated_at, created_at, id, name, slug, settings) FROM stdin;
2021-11-03 13:12:39.7361+00	2021-11-03 13:11:48.280357+00	1	redasql	default	{}
\.


--
-- Data for Name: queries; Type: TABLE DATA; Schema: public; Owner: postgres
--


COPY public.queries (updated_at, created_at, id, version, org_id, data_source_id, latest_query_data_id, name, description, query, query_hash, api_key, user_id, last_modified_by_id, is_archived, is_draft, schedule, schedule_failures, options, search_vector, tags) FROM stdin;
2021-11-03 08:26:20.930798+00	2021-11-03 08:26:05.665869+00	1	1	1	1	1	country list	\N	select * from country order by 1;	5de66f59170c0b2f3b0ef74db5850627	31YSxDSDxZUQd5modIcpvx17hoqiQcplsJdJCUio	1	1	f	f	\N	0	{"parameters": []}	'1':1B,9 'by':8 'country':2A,6 'from':5 'list':3A 'order':7 'select':4	\N
\.


--
-- Data for Name: query_results; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.query_results (id, org_id, data_source_id, query_hash, query, data, runtime, retrieved_at) FROM stdin;
1	1	1	27bda5128a5e2354eb08e638a1c44906	select * from country LIMIT 1000	{"columns": [{"name": "Code", "friendly_name": "Code", "type": "string"}, {"name": "Name", "friendly_name": "Name", "type": "string"}, {"name": "Continent", "friendly_name": "Continent", "type": "string"}, {"name": "Region", "friendly_name": "Region", "type": "string"}, {"name": "SurfaceArea", "friendly_name": "SurfaceArea", "type": "float"}, {"name": "IndepYear", "friendly_name": "IndepYear", "type": "integer"}, {"name": "Population", "friendly_name": "Population", "type": "integer"}, {"name": "LifeExpectancy", "friendly_name": "LifeExpectancy", "type": "float"}, {"name": "GNP", "friendly_name": "GNP", "type": "float"}, {"name": "GNPOld", "friendly_name": "GNPOld", "type": "float"}, {"name": "LocalName", "friendly_name": "LocalName", "type": "string"}, {"name": "GovernmentForm", "friendly_name": "GovernmentForm", "type": "string"}, {"name": "HeadOfState", "friendly_name": "HeadOfState", "type": "string"}, {"name": "Capital", "friendly_name": "Capital", "type": "integer"}, {"name": "Code2", "friendly_name": "Code2", "type": "string"}], "rows": [{"Code": "ABW", "Name": "Aruba", "Continent": "North America", "Region": "Caribbean", "SurfaceArea": 193.0, "IndepYear": null, "Population": 103000, "LifeExpectancy": 78.4, "GNP": 828.0, "GNPOld": 793.0, "LocalName": "Aruba", "GovernmentForm": "Nonmetropolitan Territory of The Netherlands", "HeadOfState": "Beatrix", "Capital": 129, "Code2": "AW"}, {"Code": "AFG", "Name": "Afghanistan", "Continent": "Asia", "Region": "Southern and Central Asia", "SurfaceArea": 652090.0, "IndepYear": 1919, "Population": 22720000, "LifeExpectancy": 45.9, "GNP": 5976.0, "GNPOld": null, "LocalName": "Afganistan/Afqanestan", "GovernmentForm": "Islamic Emirate", "HeadOfState": "Mohammad Omar", "Capital": 1, "Code2": "AF"}, {"Code": "AGO", "Name": "Angola", "Continent": "Africa", "Region": "Central Africa", "SurfaceArea": 1246700.0, "IndepYear": 1975, "Population": 12878000, "LifeExpectancy": 38.3, "GNP": 6648.0, "GNPOld": 7984.0, "LocalName": "Angola", "GovernmentForm": "Republic", "HeadOfState": "Jos\\u00e9 Eduardo dos Santos", "Capital": 56, "Code2": "AO"}, {"Code": "AIA", "Name": "Anguilla", "Continent": "North America", "Region": "Caribbean", "SurfaceArea": 96.0, "IndepYear": null, "Population": 8000, "LifeExpectancy": 76.1, "GNP": 63.2, "GNPOld": null, "LocalName": "Anguilla", "GovernmentForm": "Dependent Territory of the UK", "HeadOfState": "Elisabeth II", "Capital": 62, "Code2": "AI"}, {"Code": "ALB", "Name": "Albania", "Continent": "Europe", "Region": "Southern Europe", "SurfaceArea": 28748.0, "IndepYear": 1912, "Population": 3401200, "LifeExpectancy": 71.6, "GNP": 3205.0, "GNPOld": 2500.0, "LocalName": "Shqip\\u00ebria", "GovernmentForm": "Republic", "HeadOfState": "Rexhep Mejdani", "Capital": 34, "Code2": "AL"}, {"Code": "AND", "Name": "Andorra", "Continent": "Europe", "Region": "Southern Europe", "SurfaceArea": 468.0, "IndepYear": 1278, "Population": 78000, "LifeExpectancy": 83.5, "GNP": 1630.0, "GNPOld": null, "LocalName": "Andorra", "GovernmentForm": "Parliamentary Coprincipality", "HeadOfState": "", "Capital": 55, "Code2": "AD"}, {"Code": "ANT", "Name": "Netherlands Antilles", "Continent": "North America", "Region": "Caribbean", "SurfaceArea": 800.0, "IndepYear": null, "Population": 217000, "LifeExpectancy": 74.7, "GNP": 1941.0, "GNPOld": null, "LocalName": "Nederlandse Antillen", "GovernmentForm": "Nonmetropolitan Territory of The Netherlands", "HeadOfState": "Beatrix", "Capital": 33, "Code2": "AN"}, {"Code": "ARE", "Name": "United Arab Emirates", "Continent": "Asia", "Region": "Middle East", "SurfaceArea": 83600.0, "IndepYear": 1971, "Population": 2441000, "LifeExpectancy": 74.1, "GNP": 37966.0, "GNPOld": 36846.0, "LocalName": "Al-Imarat al-\\u00b4Arabiya al-Muttahida", "GovernmentForm": "Emirate Federation", "HeadOfState": "Zayid bin Sultan al-Nahayan", "Capital": 65, "Code2": "AE"}, {"Code": "ARG", "Name": "Argentina", "Continent": "South America", "Region": "South America", "SurfaceArea": 2780400.0, "IndepYear": 1816, "Population": 37032000, "LifeExpectancy": 75.1, "GNP": 340238.0, "GNPOld": 323310.0, "LocalName": "Argentina", "GovernmentForm": "Federal Republic", "HeadOfState": "Fernando de la R\\u00faa", "Capital": 69, "Code2": "AR"}, {"Code": "ARM", "Name": "Armenia", "Continent": "Asia", "Region": "Middle East", "SurfaceArea": 29800.0, "IndepYear": 1991, "Population": 3520000, "LifeExpectancy": 66.4, "GNP": 1813.0, "GNPOld": 1627.0, "LocalName": "Hajastan", "GovernmentForm": "Republic", "HeadOfState": "Robert Kot\\u0161arjan", "Capital": 126, "Code2": "AM"}, {"Code": "ASM", "Name": "American Samoa", "Continent": "Oceania", "Region": "Polynesia", "SurfaceArea": 199.0, "IndepYear": null, "Population": 68000, "LifeExpectancy": 75.1, "GNP": 334.0, "GNPOld": null, "LocalName": "Amerika Samoa", "GovernmentForm": "US Territory", "HeadOfState": "George W. Bush", "Capital": 54, "Code2": "AS"}, {"Code": "ATA", "Name": "Antarctica", "Continent": "Antarctica", "Region": "Antarctica", "SurfaceArea": 13120000.0, "IndepYear": null, "Population": 0, "LifeExpectancy": null, "GNP": 0.0, "GNPOld": null, "LocalName": "\\u2013", "GovernmentForm": "Co-administrated", "HeadOfState": "", "Capital": null, "Code2": "AQ"}, {"Code": "ATF", "Name": "French Southern territories", "Continent": "Antarctica", "Region": "Antarctica", "SurfaceArea": 7780.0, "IndepYear": null, "Population": 0, "LifeExpectancy": null, "GNP": 0.0, "GNPOld": null, "LocalName": "Terres australes fran\\u00e7aises", "GovernmentForm": "Nonmetropolitan Territory of France", "HeadOfState": "Jacques Chirac", "Capital": null, "Code2": "TF"}, {"Code": "ATG", "Name": "Antigua and Barbuda", "Continent": "North America", "Region": "Caribbean", "SurfaceArea": 442.0, "IndepYear": 1981, "Population": 68000, "LifeExpectancy": 70.5, "GNP": 612.0, "GNPOld": 584.0, "LocalName": "Antigua and Barbuda", "GovernmentForm": "Constitutional Monarchy", "HeadOfState": "Elisabeth II", "Capital": 63, "Code2": "AG"}, {"Code": "AUS", "Name": "Australia", "Continent": "Oceania", "Region": "Australia and New Zealand", "SurfaceArea": 7741220.0, "IndepYear": 1901, "Population": 18886000, "LifeExpectancy": 79.8, "GNP": 351182.0, "GNPOld": 392911.0, "LocalName": "Australia", "GovernmentForm": "Constitutional Monarchy, Federation", "HeadOfState": "Elisabeth II", "Capital": 135, "Code2": "AU"}, {"Code": "AUT", "Name": "Austria", "Continent": "Europe", "Region": "Western Europe", "SurfaceArea": 83859.0, "IndepYear": 1918, "Population": 8091800, "LifeExpectancy": 77.7, "GNP": 211860.0, "GNPOld": 206025.0, "LocalName": "\\u00d6sterreich", "GovernmentForm": "Federal Republic", "HeadOfState": "Thomas Klestil", "Capital": 1523, "Code2": "AT"}, {"Code": "AZE", "Name": "Azerbaijan", "Continent": "Asia", "Region": "Middle East", "SurfaceArea": 86600.0, "IndepYear": 1991, "Population": 7734000, "LifeExpectancy": 62.9, "GNP": 4127.0, "GNPOld": 4100.0, "LocalName": "Az\\u00e4rbaycan", "GovernmentForm": "Federal Republic", "HeadOfState": "Heyd\\u00e4r \\u00c4liyev", "Capital": 144, "Code2": "AZ"}, {"Code": "BDI", "Name": "Burundi", "Continent": "Africa", "Region": "Eastern Africa", "SurfaceArea": 27834.0, "IndepYear": 1962, "Population": 6695000, "LifeExpectancy": 46.2, "GNP": 903.0, "GNPOld": 982.0, "LocalName": "Burundi/Uburundi", "GovernmentForm": "Republic", "HeadOfState": "Pierre Buyoya", "Capital": 552, "Code2": "BI"}, {"Code": "BEL", "Name": "Belgium", "Continent": "Europe", "Region": "Western Europe", "SurfaceArea": 30518.0, "IndepYear": 1830, "Population": 10239000, "LifeExpectancy": 77.8, "GNP": 249704.0, "GNPOld": 243948.0, "LocalName": "Belgi\\u00eb/Belgique", "GovernmentForm": "Constitutional Monarchy, Federation", "HeadOfState": "Albert II", "Capital": 179, "Code2": "BE"}, {"Code": "BEN", "Name": "Benin", "Continent": "Africa", "Region": "Western Africa", "SurfaceArea": 112622.0, "IndepYear": 1960, "Population": 6097000, "LifeExpectancy": 50.2, "GNP": 2357.0, "GNPOld": 2141.0, "LocalName": "B\\u00e9nin", "GovernmentForm": "Republic", "HeadOfState": "Mathieu K\\u00e9r\\u00e9kou", "Capital": 187, "Code2": "BJ"}, {"Code": "BFA", "Name": "Burkina Faso", "Continent": "Africa", "Region": "Western Africa", "SurfaceArea": 274000.0, "IndepYear": 1960, "Population": 11937000, "LifeExpectancy": 46.7, "GNP": 2425.0, "GNPOld": 2201.0, "LocalName": "Burkina Faso", "GovernmentForm": "Republic", "HeadOfState": "Blaise Compaor\\u00e9", "Capital": 549, "Code2": "BF"}, {"Code": "BGD", "Name": "Bangladesh", "Continent": "Asia", "Region": "Southern and Central Asia", "SurfaceArea": 143998.0, "IndepYear": 1971, "Population": 129155000, "LifeExpectancy": 60.2, "GNP": 32852.0, "GNPOld": 31966.0, "LocalName": "Bangladesh", "GovernmentForm": "Republic", "HeadOfState": "Shahabuddin Ahmad", "Capital": 150, "Code2": "BD"}, {"Code": "BGR", "Name": "Bulgaria", "Continent": "Europe", "Region": "Eastern Europe", "SurfaceArea": 110994.0, "IndepYear": 1908, "Population": 8190900, "LifeExpectancy": 70.9, "GNP": 12178.0, "GNPOld": 10169.0, "LocalName": "Balgarija", "GovernmentForm": "Republic", "HeadOfState": "Petar Stojanov", "Capital": 539, "Code2": "BG"}, {"Code": "BHR", "Name": "Bahrain", "Continent": "Asia", "Region": "Middle East", "SurfaceArea": 694.0, "IndepYear": 1971, "Population": 617000, "LifeExpectancy": 73.0, "GNP": 6366.0, "GNPOld": 6097.0, "LocalName": "Al-Bahrayn", "GovernmentForm": "Monarchy (Emirate)", "HeadOfState": "Hamad ibn Isa al-Khalifa", "Capital": 149, "Code2": "BH"}, {"Code": "BHS", "Name": "Bahamas", "Continent": "North America", "Region": "Caribbean", "SurfaceArea": 13878.0, "IndepYear": 1973, "Population": 307000, "LifeExpectancy": 71.1, "GNP": 3527.0, "GNPOld": 3347.0, "LocalName": "The Bahamas", "GovernmentForm": "Constitutional Monarchy", "HeadOfState": "Elisabeth II", "Capital": 148, "Code2": "BS"}, {"Code": "BIH", "Name": "Bosnia and Herzegovina", "Continent": "Europe", "Region": "Southern Europe", "SurfaceArea": 51197.0, "IndepYear": 1992, "Population": 3972000, "LifeExpectancy": 71.5, "GNP": 2841.0, "GNPOld": null, "LocalName": "Bosna i Hercegovina", "GovernmentForm": "Federal Republic", "HeadOfState": "Ante Jelavic", "Capital": 201, "Code2": "BA"}, {"Code": "BLR", "Name": "Belarus", "Continent": "Europe", "Region": "Eastern Europe", "SurfaceArea": 207600.0, "IndepYear": 1991, "Population": 10236000, "LifeExpectancy": 68.0, "GNP": 13714.0, "GNPOld": null, "LocalName": "Belarus", "GovernmentForm": "Republic", "HeadOfState": "Aljaksandr Luka\\u0161enka", "Capital": 3520, "Code2": "BY"}, {"Code": "BLZ", "Name": "Belize", "Continent": "North America", "Region": "Central America", "SurfaceArea": 22696.0, "IndepYear": 1981, "Population": 241000, "LifeExpectancy": 70.9, "GNP": 630.0, "GNPOld": 616.0, "LocalName": "Belize", "GovernmentForm": "Constitutional Monarchy", "HeadOfState": "Elisabeth II", "Capital": 185, "Code2": "BZ"}, {"Code": "BMU", "Name": "Bermuda", "Continent": "North America", "Region": "North America", "SurfaceArea": 53.0, "IndepYear": null, "Population": 65000, "LifeExpectancy": 76.9, "GNP": 2328.0, "GNPOld": 2190.0, "LocalName": "Bermuda", "GovernmentForm": "Dependent Territory of the UK", "HeadOfState": "Elisabeth II", "Capital": 191, "Code2": "BM"}, {"Code": "BOL", "Name": "Bolivia", "Continent": "South America", "Region": "South America", "SurfaceArea": 1098581.0, "IndepYear": 1825, "Population": 8329000, "LifeExpectancy": 63.7, "GNP": 8571.0, "GNPOld": 7967.0, "LocalName": "Bolivia", "GovernmentForm": "Republic", "HeadOfState": "Hugo B\\u00e1nzer Su\\u00e1rez", "Capital": 194, "Code2": "BO"}, {"Code": "BRA", "Name": "Brazil", "Continent": "South America", "Region": "South America", "SurfaceArea": 8547403.0, "IndepYear": 1822, "Population": 170115000, "LifeExpectancy": 62.9, "GNP": 776739.0, "GNPOld": 804108.0, "LocalName": "Brasil", "GovernmentForm": "Federal Republic", "HeadOfState": "Fernando Henrique Cardoso", "Capital": 211, "Code2": "BR"}, {"Code": "BRB", "Name": "Barbados", "Continent": "North America", "Region": "Caribbean", "SurfaceArea": 430.0, "IndepYear": 1966, "Population": 270000, "LifeExpectancy": 73.0, "GNP": 2223.0, "GNPOld": 2186.0, "LocalName": "Barbados", "GovernmentForm": "Constitutional Monarchy", "HeadOfState": "Elisabeth II", "Capital": 174, "Code2": "BB"}, {"Code": "BRN", "Name": "Brunei", "Continent": "Asia", "Region": "Southeast Asia", "SurfaceArea": 5765.0, "IndepYear": 1984, "Population": 328000, "LifeExpectancy": 73.6, "GNP": 11705.0, "GNPOld": 12460.0, "LocalName": "Brunei Darussalam", "GovernmentForm": "Monarchy (Sultanate)", "HeadOfState": "Haji Hassan al-Bolkiah", "Capital": 538, "Code2": "BN"}, {"Code": "BTN", "Name": "Bhutan", "Continent": "Asia", "Region": "Southern and Central Asia", "SurfaceArea": 47000.0, "IndepYear": 1910, "Population": 2124000, "LifeExpectancy": 52.4, "GNP": 372.0, "GNPOld": 383.0, "LocalName": "Druk-Yul", "GovernmentForm": "Monarchy", "HeadOfState": "Jigme Singye Wangchuk", "Capital": 192, "Code2": "BT"}, {"Code": "BVT", "Name": "Bouvet Island", "Continent": "Antarctica", "Region": "Antarctica", "SurfaceArea": 59.0, "IndepYear": null, "Population": 0, "LifeExpectancy": null, "GNP": 0.0, "GNPOld": null, "LocalName": "Bouvet\\u00f8ya", "GovernmentForm": "Dependent Territory of Norway", "HeadOfState": "Harald V", "Capital": null, "Code2": "BV"}, {"Code": "BWA", "Name": "Botswana", "Continent": "Africa", "Region": "Southern Africa", "SurfaceArea": 581730.0, "IndepYear": 1966, "Population": 1622000, "LifeExpectancy": 39.3, "GNP": 4834.0, "GNPOld": 4935.0, "LocalName": "Botswana", "GovernmentForm": "Republic", "HeadOfState": "Festus G. Mogae", "Capital": 204, "Code2": "BW"}, {"Code": "CAF", "Name": "Central African Republic", "Continent": "Africa", "Region": "Central Africa", "SurfaceArea": 622984.0, "IndepYear": 1960, "Population": 3615000, "LifeExpectancy": 44.0, "GNP": 1054.0, "GNPOld": 993.0, "LocalName": "Centrafrique/B\\u00ea-Afr\\u00eeka", "GovernmentForm": "Republic", "HeadOfState": "Ange-F\\u00e9lix Patass\\u00e9", "Capital": 1889, "Code2": "CF"}, {"Code": "CAN", "Name": "Canada", "Continent": "North America", "Region": "North America", "SurfaceArea": 9970610.0, "IndepYear": 1867, "Population": 31147000, "LifeExpectancy": 79.4, "GNP": 598862.0, "GNPOld": 625626.0, "LocalName": "Canada", "GovernmentForm": "Constitutional Monarchy, Federation", "HeadOfState": "Elisabeth II", "Capital": 1822, "Code2": "CA"}, {"Code": "CCK", "Name": "Cocos (Keeling) Islands", "Continent": "Oceania", "Region": "Australia and New Zealand", "SurfaceArea": 14.0, "IndepYear": null, "Population": 600, "LifeExpectancy": null, "GNP": 0.0, "GNPOld": null, "LocalName": "Cocos (Keeling) Islands", "GovernmentForm": "Territory of Australia", "HeadOfState": "Elisabeth II", "Capital": 2317, "Code2": "CC"}, {"Code": "CHE", "Name": "Switzerland", "Continent": "Europe", "Region": "Western Europe", "SurfaceArea": 41284.0, "IndepYear": 1499, "Population": 7160400, "LifeExpectancy": 79.6, "GNP": 264478.0, "GNPOld": 256092.0, "LocalName": "Schweiz/Suisse/Svizzera/Svizra", "GovernmentForm": "Federation", "HeadOfState": "Adolf Ogi", "Capital": 3248, "Code2": "CH"}, {"Code": "CHL", "Name": "Chile", "Continent": "South America", "Region": "South America", "SurfaceArea": 756626.0, "IndepYear": 1810, "Population": 15211000, "LifeExpectancy": 75.7, "GNP": 72949.0, "GNPOld": 75780.0, "LocalName": "Chile", "GovernmentForm": "Republic", "HeadOfState": "Ricardo Lagos Escobar", "Capital": 554, "Code2": "CL"}, {"Code": "CHN", "Name": "China", "Continent": "Asia", "Region": "Eastern Asia", "SurfaceArea": 9572900.0, "IndepYear": -1523, "Population": 1277558000, "LifeExpectancy": 71.4, "GNP": 982268.0, "GNPOld": 917719.0, "LocalName": "Zhongquo", "GovernmentForm": "People'sRepublic", "HeadOfState": "Jiang Zemin", "Capital": 1891, "Code2": "CN"}, {"Code": "CIV", "Name": "C\\u00f4te d\\u2019Ivoire", "Continent": "Africa", "Region": "Western Africa", "SurfaceArea": 322463.0, "IndepYear": 1960, "Population": 14786000, "LifeExpectancy": 45.2, "GNP": 11345.0, "GNPOld": 10285.0, "LocalName": "C\\u00f4te d\\u2019Ivoire", "GovernmentForm": "Republic", "HeadOfState": "Laurent Gbagbo", "Capital": 2814, "Code2": "CI"}, {"Code": "CMR", "Name": "Cameroon", "Continent": "Africa", "Region": "Central Africa", "SurfaceArea": 475442.0, "IndepYear": 1960, "Population": 15085000, "LifeExpectancy": 54.8, "GNP": 9174.0, "GNPOld": 8596.0, "LocalName": "Cameroun/Cameroon", "GovernmentForm": "Republic", "HeadOfState": "Paul Biya", "Capital": 1804, "Code2": "CM"}, {"Code": "COD", "Name": "Congo, The Democratic Republic of the", "Continent": "Africa", "Region": "Central Africa", "SurfaceArea": 2344858.0, "IndepYear": 1960, "Population": 51654000, "LifeExpectancy": 48.8, "GNP": 6964.0, "GNPOld": 2474.0, "LocalName": "R\\u00e9publique D\\u00e9mocratique du Congo", "GovernmentForm": "Republic", "HeadOfState": "Joseph Kabila", "Capital": 2298, "Code2": "CD"}, {"Code": "COG", "Name": "Congo", "Continent": "Africa", "Region": "Central Africa", "SurfaceArea": 342000.0, "IndepYear": 1960, "Population": 2943000, "LifeExpectancy": 47.4, "GNP": 2108.0, "GNPOld": 2287.0, "LocalName": "Congo", "GovernmentForm": "Republic", "HeadOfState": "Denis Sassou-Nguesso", "Capital": 2296, "Code2": "CG"}, {"Code": "COK", "Name": "Cook Islands", "Continent": "Oceania", "Region": "Polynesia", "SurfaceArea": 236.0, "IndepYear": null, "Population": 20000, "LifeExpectancy": 71.1, "GNP": 100.0, "GNPOld": null, "LocalName": "The Cook Islands", "GovernmentForm": "Nonmetropolitan Territory of New Zealand", "HeadOfState": "Elisabeth II", "Capital": 583, "Code2": "CK"}, {"Code": "COL", "Name": "Colombia", "Continent": "South America", "Region": "South America", "SurfaceArea": 1138914.0, "IndepYear": 1810, "Population": 42321000, "LifeExpectancy": 70.3, "GNP": 102896.0, "GNPOld": 105116.0, "LocalName": "Colombia", "GovernmentForm": "Republic", "HeadOfState": "Andr\\u00e9s Pastrana Arango", "Capital": 2257, "Code2": "CO"}, {"Code": "COM", "Name": "Comoros", "Continent": "Africa", "Region": "Eastern Africa", "SurfaceArea": 1862.0, "IndepYear": 1975, "Population": 578000, "LifeExpectancy": 60.0, "GNP": 4401.0, "GNPOld": 4361.0, "LocalName": "Komori/Comores", "GovernmentForm": "Republic", "HeadOfState": "Azali Assoumani", "Capital": 2295, "Code2": "KM"}, {"Code": "CPV", "Name": "Cape Verde", "Continent": "Africa", "Region": "Western Africa", "SurfaceArea": 4033.0, "IndepYear": 1975, "Population": 428000, "LifeExpectancy": 68.9, "GNP": 435.0, "GNPOld": 420.0, "LocalName": "Cabo Verde", "GovernmentForm": "Republic", "HeadOfState": "Ant\\u00f3nio Mascarenhas Monteiro", "Capital": 1859, "Code2": "CV"}, {"Code": "CRI", "Name": "Costa Rica", "Continent": "North America", "Region": "Central America", "SurfaceArea": 51100.0, "IndepYear": 1821, "Population": 4023000, "LifeExpectancy": 75.8, "GNP": 10226.0, "GNPOld": 9757.0, "LocalName": "Costa Rica", "GovernmentForm": "Republic", "HeadOfState": "Miguel \\u00c1ngel Rodr\\u00edguez Echeverr\\u00eda", "Capital": 584, "Code2": "CR"}, {"Code": "CUB", "Name": "Cuba", "Continent": "North America", "Region": "Caribbean", "SurfaceArea": 110861.0, "IndepYear": 1902, "Population": 11201000, "LifeExpectancy": 76.2, "GNP": 17843.0, "GNPOld": 18862.0, "LocalName": "Cuba", "GovernmentForm": "Socialistic Republic", "HeadOfState": "Fidel Castro Ruz", "Capital": 2413, "Code2": "CU"}, {"Code": "CXR", "Name": "Christmas Island", "Continent": "Oceania", "Region": "Australia and New Zealand", "SurfaceArea": 135.0, "IndepYear": null, "Population": 2500, "LifeExpectancy": null, "GNP": 0.0, "GNPOld": null, "LocalName": "Christmas Island", "GovernmentForm": "Territory of Australia", "HeadOfState": "Elisabeth II", "Capital": 1791, "Code2": "CX"}, {"Code": "CYM", "Name": "Cayman Islands", "Continent": "North America", "Region": "Caribbean", "SurfaceArea": 264.0, "IndepYear": null, "Population": 38000, "LifeExpectancy": 78.9, "GNP": 1263.0, "GNPOld": 1186.0, "LocalName": "Cayman Islands", "GovernmentForm": "Dependent Territory of the UK", "HeadOfState": "Elisabeth II", "Capital": 553, "Code2": "KY"}, {"Code": "CYP", "Name": "Cyprus", "Continent": "Asia", "Region": "Middle East", "SurfaceArea": 9251.0, "IndepYear": 1960, "Population": 754700, "LifeExpectancy": 76.7, "GNP": 9333.0, "GNPOld": 8246.0, "LocalName": "K\\u00fdpros/Kibris", "GovernmentForm": "Republic", "HeadOfState": "Glafkos Klerides", "Capital": 2430, "Code2": "CY"}, {"Code": "CZE", "Name": "Czech Republic", "Continent": "Europe", "Region": "Eastern Europe", "SurfaceArea": 78866.0, "IndepYear": 1993, "Population": 10278100, "LifeExpectancy": 74.5, "GNP": 55017.0, "GNPOld": 52037.0, "LocalName": "\\u00b8esko", "GovernmentForm": "Republic", "HeadOfState": "V\\u00e1clav Havel", "Capital": 3339, "Code2": "CZ"}, {"Code": "DEU", "Name": "Germany", "Continent": "Europe", "Region": "Western Europe", "SurfaceArea": 357022.0, "IndepYear": 1955, "Population": 82164700, "LifeExpectancy": 77.4, "GNP": 2133367.0, "GNPOld": 2102826.0, "LocalName": "Deutschland", "GovernmentForm": "Federal Republic", "HeadOfState": "Johannes Rau", "Capital": 3068, "Code2": "DE"}, {"Code": "DJI", "Name": "Djibouti", "Continent": "Africa", "Region": "Eastern Africa", "SurfaceArea": 23200.0, "IndepYear": 1977, "Population": 638000, "LifeExpectancy": 50.8, "GNP": 382.0, "GNPOld": 373.0, "LocalName": "Djibouti/Jibuti", "GovernmentForm": "Republic", "HeadOfState": "Ismail Omar Guelleh", "Capital": 585, "Code2": "DJ"}, {"Code": "DMA", "Name": "Dominica", "Continent": "North America", "Region": "Caribbean", "SurfaceArea": 751.0, "IndepYear": 1978, "Population": 71000, "LifeExpectancy": 73.4, "GNP": 256.0, "GNPOld": 243.0, "LocalName": "Dominica", "GovernmentForm": "Republic", "HeadOfState": "Vernon Shaw", "Capital": 586, "Code2": "DM"}, {"Code": "DNK", "Name": "Denmark", "Continent": "Europe", "Region": "Nordic Countries", "SurfaceArea": 43094.0, "IndepYear": 800, "Population": 5330000, "LifeExpectancy": 76.5, "GNP": 174099.0, "GNPOld": 169264.0, "LocalName": "Danmark", "GovernmentForm": "Constitutional Monarchy", "HeadOfState": "Margrethe II", "Capital": 3315, "Code2": "DK"}, {"Code": "DOM", "Name": "Dominican Republic", "Continent": "North America", "Region": "Caribbean", "SurfaceArea": 48511.0, "IndepYear": 1844, "Population": 8495000, "LifeExpectancy": 73.2, "GNP": 15846.0, "GNPOld": 15076.0, "LocalName": "Rep\\u00fablica Dominicana", "GovernmentForm": "Republic", "HeadOfState": "Hip\\u00f3lito Mej\\u00eda Dom\\u00ednguez", "Capital": 587, "Code2": "DO"}, {"Code": "DZA", "Name": "Algeria", "Continent": "Africa", "Region": "Northern Africa", "SurfaceArea": 2381741.0, "IndepYear": 1962, "Population": 31471000, "LifeExpectancy": 69.7, "GNP": 49982.0, "GNPOld": 46966.0, "LocalName": "Al-Jaza\\u2019ir/Alg\\u00e9rie", "GovernmentForm": "Republic", "HeadOfState": "Abdelaziz Bouteflika", "Capital": 35, "Code2": "DZ"}, {"Code": "ECU", "Name": "Ecuador", "Continent": "South America", "Region": "South America", "SurfaceArea": 283561.0, "IndepYear": 1822, "Population": 12646000, "LifeExpectancy": 71.1, "GNP": 19770.0, "GNPOld": 19769.0, "LocalName": "Ecuador", "GovernmentForm": "Republic", "HeadOfState": "Gustavo Noboa Bejarano", "Capital": 594, "Code2": "EC"}, {"Code": "EGY", "Name": "Egypt", "Continent": "Africa", "Region": "Northern Africa", "SurfaceArea": 1001449.0, "IndepYear": 1922, "Population": 68470000, "LifeExpectancy": 63.3, "GNP": 82710.0, "GNPOld": 75617.0, "LocalName": "Misr", "GovernmentForm": "Republic", "HeadOfState": "Hosni Mubarak", "Capital": 608, "Code2": "EG"}, {"Code": "ERI", "Name": "Eritrea", "Continent": "Africa", "Region": "Eastern Africa", "SurfaceArea": 117600.0, "IndepYear": 1993, "Population": 3850000, "LifeExpectancy": 55.8, "GNP": 650.0, "GNPOld": 755.0, "LocalName": "Ertra", "GovernmentForm": "Republic", "HeadOfState": "Isayas Afewerki [Isaias Afwerki]", "Capital": 652, "Code2": "ER"}, {"Code": "ESH", "Name": "Western Sahara", "Continent": "Africa", "Region": "Northern Africa", "SurfaceArea": 266000.0, "IndepYear": null, "Population": 293000, "LifeExpectancy": 49.8, "GNP": 60.0, "GNPOld": null, "LocalName": "As-Sahrawiya", "GovernmentForm": "Occupied by Marocco", "HeadOfState": "Mohammed Abdel Aziz", "Capital": 2453, "Code2": "EH"}, {"Code": "ESP", "Name": "Spain", "Continent": "Europe", "Region": "Southern Europe", "SurfaceArea": 505992.0, "IndepYear": 1492, "Population": 39441700, "LifeExpectancy": 78.8, "GNP": 553233.0, "GNPOld": 532031.0, "LocalName": "Espa\\u00f1a", "GovernmentForm": "Constitutional Monarchy", "HeadOfState": "Juan Carlos I", "Capital": 653, "Code2": "ES"}, {"Code": "EST", "Name": "Estonia", "Continent": "Europe", "Region": "Baltic Countries", "SurfaceArea": 45227.0, "IndepYear": 1991, "Population": 1439200, "LifeExpectancy": 69.5, "GNP": 5328.0, "GNPOld": 3371.0, "LocalName": "Eesti", "GovernmentForm": "Republic", "HeadOfState": "Lennart Meri", "Capital": 3791, "Code2": "EE"}, {"Code": "ETH", "Name": "Ethiopia", "Continent": "Africa", "Region": "Eastern Africa", "SurfaceArea": 1104300.0, "IndepYear": -1000, "Population": 62565000, "LifeExpectancy": 45.2, "GNP": 6353.0, "GNPOld": 6180.0, "LocalName": "YeItyop\\u00b4iya", "GovernmentForm": "Republic", "HeadOfState": "Negasso Gidada", "Capital": 756, "Code2": "ET"}, {"Code": "FIN", "Name": "Finland", "Continent": "Europe", "Region": "Nordic Countries", "SurfaceArea": 338145.0, "IndepYear": 1917, "Population": 5171300, "LifeExpectancy": 77.4, "GNP": 121914.0, "GNPOld": 119833.0, "LocalName": "Suomi", "GovernmentForm": "Republic", "HeadOfState": "Tarja Halonen", "Capital": 3236, "Code2": "FI"}, {"Code": "FJI", "Name": "Fiji Islands", "Continent": "Oceania", "Region": "Melanesia", "SurfaceArea": 18274.0, "IndepYear": 1970, "Population": 817000, "LifeExpectancy": 67.9, "GNP": 1536.0, "GNPOld": 2149.0, "LocalName": "Fiji Islands", "GovernmentForm": "Republic", "HeadOfState": "Josefa Iloilo", "Capital": 764, "Code2": "FJ"}, {"Code": "FLK", "Name": "Falkland Islands", "Continent": "South America", "Region": "South America", "SurfaceArea": 12173.0, "IndepYear": null, "Population": 2000, "LifeExpectancy": null, "GNP": 0.0, "GNPOld": null, "LocalName": "Falkland Islands", "GovernmentForm": "Dependent Territory of the UK", "HeadOfState": "Elisabeth II", "Capital": 763, "Code2": "FK"}, {"Code": "FRA", "Name": "France", "Continent": "Europe", "Region": "Western Europe", "SurfaceArea": 551500.0, "IndepYear": 843, "Population": 59225700, "LifeExpectancy": 78.8, "GNP": 1424285.0, "GNPOld": 1392448.0, "LocalName": "France", "GovernmentForm": "Republic", "HeadOfState": "Jacques Chirac", "Capital": 2974, "Code2": "FR"}, {"Code": "FRO", "Name": "Faroe Islands", "Continent": "Europe", "Region": "Nordic Countries", "SurfaceArea": 1399.0, "IndepYear": null, "Population": 43000, "LifeExpectancy": 78.4, "GNP": 0.0, "GNPOld": null, "LocalName": "F\\u00f8royar", "GovernmentForm": "Part of Denmark", "HeadOfState": "Margrethe II", "Capital": 901, "Code2": "FO"}, {"Code": "FSM", "Name": "Micronesia, Federated States of", "Continent": "Oceania", "Region": "Micronesia", "SurfaceArea": 702.0, "IndepYear": 1990, "Population": 119000, "LifeExpectancy": 68.6, "GNP": 212.0, "GNPOld": null, "LocalName": "Micronesia", "GovernmentForm": "Federal Republic", "HeadOfState": "Leo A. Falcam", "Capital": 2689, "Code2": "FM"}, {"Code": "GAB", "Name": "Gabon", "Continent": "Africa", "Region": "Central Africa", "SurfaceArea": 267668.0, "IndepYear": 1960, "Population": 1226000, "LifeExpectancy": 50.1, "GNP": 5493.0, "GNPOld": 5279.0, "LocalName": "Le Gabon", "GovernmentForm": "Republic", "HeadOfState": "Omar Bongo", "Capital": 902, "Code2": "GA"}, {"Code": "GBR", "Name": "United Kingdom", "Continent": "Europe", "Region": "British Islands", "SurfaceArea": 242900.0, "IndepYear": 1066, "Population": 59623400, "LifeExpectancy": 77.7, "GNP": 1378330.0, "GNPOld": 1296830.0, "LocalName": "United Kingdom", "GovernmentForm": "Constitutional Monarchy", "HeadOfState": "Elisabeth II", "Capital": 456, "Code2": "GB"}, {"Code": "GEO", "Name": "Georgia", "Continent": "Asia", "Region": "Middle East", "SurfaceArea": 69700.0, "IndepYear": 1991, "Population": 4968000, "LifeExpectancy": 64.5, "GNP": 6064.0, "GNPOld": 5924.0, "LocalName": "Sakartvelo", "GovernmentForm": "Republic", "HeadOfState": "Eduard \\u0160evardnadze", "Capital": 905, "Code2": "GE"}, {"Code": "GHA", "Name": "Ghana", "Continent": "Africa", "Region": "Western Africa", "SurfaceArea": 238533.0, "IndepYear": 1957, "Population": 20212000, "LifeExpectancy": 57.4, "GNP": 7137.0, "GNPOld": 6884.0, "LocalName": "Ghana", "GovernmentForm": "Republic", "HeadOfState": "John Kufuor", "Capital": 910, "Code2": "GH"}, {"Code": "GIB", "Name": "Gibraltar", "Continent": "Europe", "Region": "Southern Europe", "SurfaceArea": 6.0, "IndepYear": null, "Population": 25000, "LifeExpectancy": 79.0, "GNP": 258.0, "GNPOld": null, "LocalName": "Gibraltar", "GovernmentForm": "Dependent Territory of the UK", "HeadOfState": "Elisabeth II", "Capital": 915, "Code2": "GI"}, {"Code": "GIN", "Name": "Guinea", "Continent": "Africa", "Region": "Western Africa", "SurfaceArea": 245857.0, "IndepYear": 1958, "Population": 7430000, "LifeExpectancy": 45.6, "GNP": 2352.0, "GNPOld": 2383.0, "LocalName": "Guin\\u00e9e", "GovernmentForm": "Republic", "HeadOfState": "Lansana Cont\\u00e9", "Capital": 926, "Code2": "GN"}, {"Code": "GLP", "Name": "Guadeloupe", "Continent": "North America", "Region": "Caribbean", "SurfaceArea": 1705.0, "IndepYear": null, "Population": 456000, "LifeExpectancy": 77.0, "GNP": 3501.0, "GNPOld": null, "LocalName": "Guadeloupe", "GovernmentForm": "Overseas Department of France", "HeadOfState": "Jacques Chirac", "Capital": 919, "Code2": "GP"}, {"Code": "GMB", "Name": "Gambia", "Continent": "Africa", "Region": "Western Africa", "SurfaceArea": 11295.0, "IndepYear": 1965, "Population": 1305000, "LifeExpectancy": 53.2, "GNP": 320.0, "GNPOld": 325.0, "LocalName": "The Gambia", "GovernmentForm": "Republic", "HeadOfState": "Yahya Jammeh", "Capital": 904, "Code2": "GM"}, {"Code": "GNB", "Name": "Guinea-Bissau", "Continent": "Africa", "Region": "Western Africa", "SurfaceArea": 36125.0, "IndepYear": 1974, "Population": 1213000, "LifeExpectancy": 49.0, "GNP": 293.0, "GNPOld": 272.0, "LocalName": "Guin\\u00e9-Bissau", "GovernmentForm": "Republic", "HeadOfState": "Kumba Ial\\u00e1", "Capital": 927, "Code2": "GW"}, {"Code": "GNQ", "Name": "Equatorial Guinea", "Continent": "Africa", "Region": "Central Africa", "SurfaceArea": 28051.0, "IndepYear": 1968, "Population": 453000, "LifeExpectancy": 53.6, "GNP": 283.0, "GNPOld": 542.0, "LocalName": "Guinea Ecuatorial", "GovernmentForm": "Republic", "HeadOfState": "Teodoro Obiang Nguema Mbasogo", "Capital": 2972, "Code2": "GQ"}, {"Code": "GRC", "Name": "Greece", "Continent": "Europe", "Region": "Southern Europe", "SurfaceArea": 131626.0, "IndepYear": 1830, "Population": 10545700, "LifeExpectancy": 78.4, "GNP": 120724.0, "GNPOld": 119946.0, "LocalName": "Ell\\u00e1da", "GovernmentForm": "Republic", "HeadOfState": "Kostis Stefanopoulos", "Capital": 2401, "Code2": "GR"}, {"Code": "GRD", "Name": "Grenada", "Continent": "North America", "Region": "Caribbean", "SurfaceArea": 344.0, "IndepYear": 1974, "Population": 94000, "LifeExpectancy": 64.5, "GNP": 318.0, "GNPOld": null, "LocalName": "Grenada", "GovernmentForm": "Constitutional Monarchy", "HeadOfState": "Elisabeth II", "Capital": 916, "Code2": "GD"}, {"Code": "GRL", "Name": "Greenland", "Continent": "North America", "Region": "North America", "SurfaceArea": 2166090.0, "IndepYear": null, "Population": 56000, "LifeExpectancy": 68.1, "GNP": 0.0, "GNPOld": null, "LocalName": "Kalaallit Nunaat/Gr\\u00f8nland", "GovernmentForm": "Part of Denmark", "HeadOfState": "Margrethe II", "Capital": 917, "Code2": "GL"}, {"Code": "GTM", "Name": "Guatemala", "Continent": "North America", "Region": "Central America", "SurfaceArea": 108889.0, "IndepYear": 1821, "Population": 11385000, "LifeExpectancy": 66.2, "GNP": 19008.0, "GNPOld": 17797.0, "LocalName": "Guatemala", "GovernmentForm": "Republic", "HeadOfState": "Alfonso Portillo Cabrera", "Capital": 922, "Code2": "GT"}, {"Code": "GUF", "Name": "French Guiana", "Continent": "South America", "Region": "South America", "SurfaceArea": 90000.0, "IndepYear": null, "Population": 181000, "LifeExpectancy": 76.1, "GNP": 681.0, "GNPOld": null, "LocalName": "Guyane fran\\u00e7aise", "GovernmentForm": "Overseas Department of France", "HeadOfState": "Jacques Chirac", "Capital": 3014, "Code2": "GF"}, {"Code": "GUM", "Name": "Guam", "Continent": "Oceania", "Region": "Micronesia", "SurfaceArea": 549.0, "IndepYear": null, "Population": 168000, "LifeExpectancy": 77.8, "GNP": 1197.0, "GNPOld": 1136.0, "LocalName": "Guam", "GovernmentForm": "US Territory", "HeadOfState": "George W. Bush", "Capital": 921, "Code2": "GU"}, {"Code": "GUY", "Name": "Guyana", "Continent": "South America", "Region": "South America", "SurfaceArea": 214969.0, "IndepYear": 1966, "Population": 861000, "LifeExpectancy": 64.0, "GNP": 722.0, "GNPOld": 743.0, "LocalName": "Guyana", "GovernmentForm": "Republic", "HeadOfState": "Bharrat Jagdeo", "Capital": 928, "Code2": "GY"}, {"Code": "HKG", "Name": "Hong Kong", "Continent": "Asia", "Region": "Eastern Asia", "SurfaceArea": 1075.0, "IndepYear": null, "Population": 6782000, "LifeExpectancy": 79.5, "GNP": 166448.0, "GNPOld": 173610.0, "LocalName": "Xianggang/Hong Kong", "GovernmentForm": "Special Administrative Region of China", "HeadOfState": "Jiang Zemin", "Capital": 937, "Code2": "HK"}, {"Code": "HMD", "Name": "Heard Island and McDonald Islands", "Continent": "Antarctica", "Region": "Antarctica", "SurfaceArea": 359.0, "IndepYear": null, "Population": 0, "LifeExpectancy": null, "GNP": 0.0, "GNPOld": null, "LocalName": "Heard and McDonald Islands", "GovernmentForm": "Territory of Australia", "HeadOfState": "Elisabeth II", "Capital": null, "Code2": "HM"}, {"Code": "HND", "Name": "Honduras", "Continent": "North America", "Region": "Central America", "SurfaceArea": 112088.0, "IndepYear": 1838, "Population": 6485000, "LifeExpectancy": 69.9, "GNP": 5333.0, "GNPOld": 4697.0, "LocalName": "Honduras", "GovernmentForm": "Republic", "HeadOfState": "Carlos Roberto Flores Facuss\\u00e9", "Capital": 933, "Code2": "HN"}, {"Code": "HRV", "Name": "Croatia", "Continent": "Europe", "Region": "Southern Europe", "SurfaceArea": 56538.0, "IndepYear": 1991, "Population": 4473000, "LifeExpectancy": 73.7, "GNP": 20208.0, "GNPOld": 19300.0, "LocalName": "Hrvatska", "GovernmentForm": "Republic", "HeadOfState": "\\u0160tipe Mesic", "Capital": 2409, "Code2": "HR"}, {"Code": "HTI", "Name": "Haiti", "Continent": "North America", "Region": "Caribbean", "SurfaceArea": 27750.0, "IndepYear": 1804, "Population": 8222000, "LifeExpectancy": 49.2, "GNP": 3459.0, "GNPOld": 3107.0, "LocalName": "Ha\\u00efti/Dayti", "GovernmentForm": "Republic", "HeadOfState": "Jean-Bertrand Aristide", "Capital": 929, "Code2": "HT"}, {"Code": "HUN", "Name": "Hungary", "Continent": "Europe", "Region": "Eastern Europe", "SurfaceArea": 93030.0, "IndepYear": 1918, "Population": 10043200, "LifeExpectancy": 71.4, "GNP": 48267.0, "GNPOld": 45914.0, "LocalName": "Magyarorsz\\u00e1g", "GovernmentForm": "Republic", "HeadOfState": "Ferenc M\\u00e1dl", "Capital": 3483, "Code2": "HU"}, {"Code": "IDN", "Name": "Indonesia", "Continent": "Asia", "Region": "Southeast Asia", "SurfaceArea": 1904569.0, "IndepYear": 1945, "Population": 212107000, "LifeExpectancy": 68.0, "GNP": 84982.0, "GNPOld": 215002.0, "LocalName": "Indonesia", "GovernmentForm": "Republic", "HeadOfState": "Abdurrahman Wahid", "Capital": 939, "Code2": "ID"}, {"Code": "IND", "Name": "India", "Continent": "Asia", "Region": "Southern and Central Asia", "SurfaceArea": 3287263.0, "IndepYear": 1947, "Population": 1013662000, "LifeExpectancy": 62.5, "GNP": 447114.0, "GNPOld": 430572.0, "LocalName": "Bharat/India", "GovernmentForm": "Federal Republic", "HeadOfState": "Kocheril Raman Narayanan", "Capital": 1109, "Code2": "IN"}, {"Code": "IOT", "Name": "British Indian Ocean Territory", "Continent": "Africa", "Region": "Eastern Africa", "SurfaceArea": 78.0, "IndepYear": null, "Population": 0, "LifeExpectancy": null, "GNP": 0.0, "GNPOld": null, "LocalName": "British Indian Ocean Territory", "GovernmentForm": "Dependent Territory of the UK", "HeadOfState": "Elisabeth II", "Capital": null, "Code2": "IO"}, {"Code": "IRL", "Name": "Ireland", "Continent": "Europe", "Region": "British Islands", "SurfaceArea": 70273.0, "IndepYear": 1921, "Population": 3775100, "LifeExpectancy": 76.8, "GNP": 75921.0, "GNPOld": 73132.0, "LocalName": "Ireland/\\u00c9ire", "GovernmentForm": "Republic", "HeadOfState": "Mary McAleese", "Capital": 1447, "Code2": "IE"}, {"Code": "IRN", "Name": "Iran", "Continent": "Asia", "Region": "Southern and Central Asia", "SurfaceArea": 1648195.0, "IndepYear": 1906, "Population": 67702000, "LifeExpectancy": 69.7, "GNP": 195746.0, "GNPOld": 160151.0, "LocalName": "Iran", "GovernmentForm": "Islamic Republic", "HeadOfState": "Ali Mohammad Khatami-Ardakani", "Capital": 1380, "Code2": "IR"}, {"Code": "IRQ", "Name": "Iraq", "Continent": "Asia", "Region": "Middle East", "SurfaceArea": 438317.0, "IndepYear": 1932, "Population": 23115000, "LifeExpectancy": 66.5, "GNP": 11500.0, "GNPOld": null, "LocalName": "Al-\\u00b4Iraq", "GovernmentForm": "Republic", "HeadOfState": "Saddam Hussein al-Takriti", "Capital": 1365, "Code2": "IQ"}, {"Code": "ISL", "Name": "Iceland", "Continent": "Europe", "Region": "Nordic Countries", "SurfaceArea": 103000.0, "IndepYear": 1944, "Population": 279000, "LifeExpectancy": 79.4, "GNP": 8255.0, "GNPOld": 7474.0, "LocalName": "\\u00cdsland", "GovernmentForm": "Republic", "HeadOfState": "\\u00d3lafur Ragnar Gr\\u00edmsson", "Capital": 1449, "Code2": "IS"}, {"Code": "ISR", "Name": "Israel", "Continent": "Asia", "Region": "Middle East", "SurfaceArea": 21056.0, "IndepYear": 1948, "Population": 6217000, "LifeExpectancy": 78.6, "GNP": 97477.0, "GNPOld": 98577.0, "LocalName": "Yisra\\u2019el/Isra\\u2019il", "GovernmentForm": "Republic", "HeadOfState": "Moshe Katzav", "Capital": 1450, "Code2": "IL"}, {"Code": "ITA", "Name": "Italy", "Continent": "Europe", "Region": "Southern Europe", "SurfaceArea": 301316.0, "IndepYear": 1861, "Population": 57680000, "LifeExpectancy": 79.0, "GNP": 1161755.0, "GNPOld": 1145372.0, "LocalName": "Italia", "GovernmentForm": "Republic", "HeadOfState": "Carlo Azeglio Ciampi", "Capital": 1464, "Code2": "IT"}, {"Code": "JAM", "Name": "Jamaica", "Continent": "North America", "Region": "Caribbean", "SurfaceArea": 10990.0, "IndepYear": 1962, "Population": 2583000, "LifeExpectancy": 75.2, "GNP": 6871.0, "GNPOld": 6722.0, "LocalName": "Jamaica", "GovernmentForm": "Constitutional Monarchy", "HeadOfState": "Elisabeth II", "Capital": 1530, "Code2": "JM"}, {"Code": "JOR", "Name": "Jordan", "Continent": "Asia", "Region": "Middle East", "SurfaceArea": 88946.0, "IndepYear": 1946, "Population": 5083000, "LifeExpectancy": 77.4, "GNP": 7526.0, "GNPOld": 7051.0, "LocalName": "Al-Urdunn", "GovernmentForm": "Constitutional Monarchy", "HeadOfState": "Abdullah II", "Capital": 1786, "Code2": "JO"}, {"Code": "JPN", "Name": "Japan", "Continent": "Asia", "Region": "Eastern Asia", "SurfaceArea": 377829.0, "IndepYear": -660, "Population": 126714000, "LifeExpectancy": 80.7, "GNP": 3787042.0, "GNPOld": 4192638.0, "LocalName": "Nihon/Nippon", "GovernmentForm": "Constitutional Monarchy", "HeadOfState": "Akihito", "Capital": 1532, "Code2": "JP"}, {"Code": "KAZ", "Name": "Kazakstan", "Continent": "Asia", "Region": "Southern and Central Asia", "SurfaceArea": 2724900.0, "IndepYear": 1991, "Population": 16223000, "LifeExpectancy": 63.2, "GNP": 24375.0, "GNPOld": 23383.0, "LocalName": "Qazaqstan", "GovernmentForm": "Republic", "HeadOfState": "Nursultan Nazarbajev", "Capital": 1864, "Code2": "KZ"}, {"Code": "KEN", "Name": "Kenya", "Continent": "Africa", "Region": "Eastern Africa", "SurfaceArea": 580367.0, "IndepYear": 1963, "Population": 30080000, "LifeExpectancy": 48.0, "GNP": 9217.0, "GNPOld": 10241.0, "LocalName": "Kenya", "GovernmentForm": "Republic", "HeadOfState": "Daniel arap Moi", "Capital": 1881, "Code2": "KE"}, {"Code": "KGZ", "Name": "Kyrgyzstan", "Continent": "Asia", "Region": "Southern and Central Asia", "SurfaceArea": 199900.0, "IndepYear": 1991, "Population": 4699000, "LifeExpectancy": 63.4, "GNP": 1626.0, "GNPOld": 1767.0, "LocalName": "Kyrgyzstan", "GovernmentForm": "Republic", "HeadOfState": "Askar Akajev", "Capital": 2253, "Code2": "KG"}, {"Code": "KHM", "Name": "Cambodia", "Continent": "Asia", "Region": "Southeast Asia", "SurfaceArea": 181035.0, "IndepYear": 1953, "Population": 11168000, "LifeExpectancy": 56.5, "GNP": 5121.0, "GNPOld": 5670.0, "LocalName": "K\\u00e2mpuch\\u00e9a", "GovernmentForm": "Constitutional Monarchy", "HeadOfState": "Norodom Sihanouk", "Capital": 1800, "Code2": "KH"}, {"Code": "KIR", "Name": "Kiribati", "Continent": "Oceania", "Region": "Micronesia", "SurfaceArea": 726.0, "IndepYear": 1979, "Population": 83000, "LifeExpectancy": 59.8, "GNP": 40.7, "GNPOld": null, "LocalName": "Kiribati", "GovernmentForm": "Republic", "HeadOfState": "Teburoro Tito", "Capital": 2256, "Code2": "KI"}, {"Code": "KNA", "Name": "Saint Kitts and Nevis", "Continent": "North America", "Region": "Caribbean", "SurfaceArea": 261.0, "IndepYear": 1983, "Population": 38000, "LifeExpectancy": 70.7, "GNP": 299.0, "GNPOld": null, "LocalName": "Saint Kitts and Nevis", "GovernmentForm": "Constitutional Monarchy", "HeadOfState": "Elisabeth II", "Capital": 3064, "Code2": "KN"}, {"Code": "KOR", "Name": "South Korea", "Continent": "Asia", "Region": "Eastern Asia", "SurfaceArea": 99434.0, "IndepYear": 1948, "Population": 46844000, "LifeExpectancy": 74.4, "GNP": 320749.0, "GNPOld": 442544.0, "LocalName": "Taehan Min\\u2019guk (Namhan)", "GovernmentForm": "Republic", "HeadOfState": "Kim Dae-jung", "Capital": 2331, "Code2": "KR"}, {"Code": "KWT", "Name": "Kuwait", "Continent": "Asia", "Region": "Middle East", "SurfaceArea": 17818.0, "IndepYear": 1961, "Population": 1972000, "LifeExpectancy": 76.1, "GNP": 27037.0, "GNPOld": 30373.0, "LocalName": "Al-Kuwayt", "GovernmentForm": "Constitutional Monarchy (Emirate)", "HeadOfState": "Jabir al-Ahmad al-Jabir al-Sabah", "Capital": 2429, "Code2": "KW"}, {"Code": "LAO", "Name": "Laos", "Continent": "Asia", "Region": "Southeast Asia", "SurfaceArea": 236800.0, "IndepYear": 1953, "Population": 5433000, "LifeExpectancy": 53.1, "GNP": 1292.0, "GNPOld": 1746.0, "LocalName": "Lao", "GovernmentForm": "Republic", "HeadOfState": "Khamtay Siphandone", "Capital": 2432, "Code2": "LA"}, {"Code": "LBN", "Name": "Lebanon", "Continent": "Asia", "Region": "Middle East", "SurfaceArea": 10400.0, "IndepYear": 1941, "Population": 3282000, "LifeExpectancy": 71.3, "GNP": 17121.0, "GNPOld": 15129.0, "LocalName": "Lubnan", "GovernmentForm": "Republic", "HeadOfState": "\\u00c9mile Lahoud", "Capital": 2438, "Code2": "LB"}, {"Code": "LBR", "Name": "Liberia", "Continent": "Africa", "Region": "Western Africa", "SurfaceArea": 111369.0, "IndepYear": 1847, "Population": 3154000, "LifeExpectancy": 51.0, "GNP": 2012.0, "GNPOld": null, "LocalName": "Liberia", "GovernmentForm": "Republic", "HeadOfState": "Charles Taylor", "Capital": 2440, "Code2": "LR"}, {"Code": "LBY", "Name": "Libyan Arab Jamahiriya", "Continent": "Africa", "Region": "Northern Africa", "SurfaceArea": 1759540.0, "IndepYear": 1951, "Population": 5605000, "LifeExpectancy": 75.5, "GNP": 44806.0, "GNPOld": 40562.0, "LocalName": "Libiya", "GovernmentForm": "Socialistic State", "HeadOfState": "Muammar al-Qadhafi", "Capital": 2441, "Code2": "LY"}, {"Code": "LCA", "Name": "Saint Lucia", "Continent": "North America", "Region": "Caribbean", "SurfaceArea": 622.0, "IndepYear": 1979, "Population": 154000, "LifeExpectancy": 72.3, "GNP": 571.0, "GNPOld": null, "LocalName": "Saint Lucia", "GovernmentForm": "Constitutional Monarchy", "HeadOfState": "Elisabeth II", "Capital": 3065, "Code2": "LC"}, {"Code": "LIE", "Name": "Liechtenstein", "Continent": "Europe", "Region": "Western Europe", "SurfaceArea": 160.0, "IndepYear": 1806, "Population": 32300, "LifeExpectancy": 78.8, "GNP": 1119.0, "GNPOld": 1084.0, "LocalName": "Liechtenstein", "GovernmentForm": "Constitutional Monarchy", "HeadOfState": "Hans-Adam II", "Capital": 2446, "Code2": "LI"}, {"Code": "LKA", "Name": "Sri Lanka", "Continent": "Asia", "Region": "Southern and Central Asia", "SurfaceArea": 65610.0, "IndepYear": 1948, "Population": 18827000, "LifeExpectancy": 71.8, "GNP": 15706.0, "GNPOld": 15091.0, "LocalName": "Sri Lanka/Ilankai", "GovernmentForm": "Republic", "HeadOfState": "Chandrika Kumaratunga", "Capital": 3217, "Code2": "LK"}, {"Code": "LSO", "Name": "Lesotho", "Continent": "Africa", "Region": "Southern Africa", "SurfaceArea": 30355.0, "IndepYear": 1966, "Population": 2153000, "LifeExpectancy": 50.8, "GNP": 1061.0, "GNPOld": 1161.0, "LocalName": "Lesotho", "GovernmentForm": "Constitutional Monarchy", "HeadOfState": "Letsie III", "Capital": 2437, "Code2": "LS"}, {"Code": "LTU", "Name": "Lithuania", "Continent": "Europe", "Region": "Baltic Countries", "SurfaceArea": 65301.0, "IndepYear": 1991, "Population": 3698500, "LifeExpectancy": 69.1, "GNP": 10692.0, "GNPOld": 9585.0, "LocalName": "Lietuva", "GovernmentForm": "Republic", "HeadOfState": "Valdas Adamkus", "Capital": 2447, "Code2": "LT"}, {"Code": "LUX", "Name": "Luxembourg", "Continent": "Europe", "Region": "Western Europe", "SurfaceArea": 2586.0, "IndepYear": 1867, "Population": 435700, "LifeExpectancy": 77.1, "GNP": 16321.0, "GNPOld": 15519.0, "LocalName": "Luxembourg/L\\u00ebtzebuerg", "GovernmentForm": "Constitutional Monarchy", "HeadOfState": "Henri", "Capital": 2452, "Code2": "LU"}, {"Code": "LVA", "Name": "Latvia", "Continent": "Europe", "Region": "Baltic Countries", "SurfaceArea": 64589.0, "IndepYear": 1991, "Population": 2424200, "LifeExpectancy": 68.4, "GNP": 6398.0, "GNPOld": 5639.0, "LocalName": "Latvija", "GovernmentForm": "Republic", "HeadOfState": "Vaira Vike-Freiberga", "Capital": 2434, "Code2": "LV"}, {"Code": "MAC", "Name": "Macao", "Continent": "Asia", "Region": "Eastern Asia", "SurfaceArea": 18.0, "IndepYear": null, "Population": 473000, "LifeExpectancy": 81.6, "GNP": 5749.0, "GNPOld": 5940.0, "LocalName": "Macau/Aomen", "GovernmentForm": "Special Administrative Region of China", "HeadOfState": "Jiang Zemin", "Capital": 2454, "Code2": "MO"}, {"Code": "MAR", "Name": "Morocco", "Continent": "Africa", "Region": "Northern Africa", "SurfaceArea": 446550.0, "IndepYear": 1956, "Population": 28351000, "LifeExpectancy": 69.1, "GNP": 36124.0, "GNPOld": 33514.0, "LocalName": "Al-Maghrib", "GovernmentForm": "Constitutional Monarchy", "HeadOfState": "Mohammed VI", "Capital": 2486, "Code2": "MA"}, {"Code": "MCO", "Name": "Monaco", "Continent": "Europe", "Region": "Western Europe", "SurfaceArea": 1.5, "IndepYear": 1861, "Population": 34000, "LifeExpectancy": 78.8, "GNP": 776.0, "GNPOld": null, "LocalName": "Monaco", "GovernmentForm": "Constitutional Monarchy", "HeadOfState": "Rainier III", "Capital": 2695, "Code2": "MC"}, {"Code": "MDA", "Name": "Moldova", "Continent": "Europe", "Region": "Eastern Europe", "SurfaceArea": 33851.0, "IndepYear": 1991, "Population": 4380000, "LifeExpectancy": 64.5, "GNP": 1579.0, "GNPOld": 1872.0, "LocalName": "Moldova", "GovernmentForm": "Republic", "HeadOfState": "Vladimir Voronin", "Capital": 2690, "Code2": "MD"}, {"Code": "MDG", "Name": "Madagascar", "Continent": "Africa", "Region": "Eastern Africa", "SurfaceArea": 587041.0, "IndepYear": 1960, "Population": 15942000, "LifeExpectancy": 55.0, "GNP": 3750.0, "GNPOld": 3545.0, "LocalName": "Madagasikara/Madagascar", "GovernmentForm": "Federal Republic", "HeadOfState": "Didier Ratsiraka", "Capital": 2455, "Code2": "MG"}, {"Code": "MDV", "Name": "Maldives", "Continent": "Asia", "Region": "Southern and Central Asia", "SurfaceArea": 298.0, "IndepYear": 1965, "Population": 286000, "LifeExpectancy": 62.2, "GNP": 199.0, "GNPOld": null, "LocalName": "Dhivehi Raajje/Maldives", "GovernmentForm": "Republic", "HeadOfState": "Maumoon Abdul Gayoom", "Capital": 2463, "Code2": "MV"}, {"Code": "MEX", "Name": "Mexico", "Continent": "North America", "Region": "Central America", "SurfaceArea": 1958201.0, "IndepYear": 1810, "Population": 98881000, "LifeExpectancy": 71.5, "GNP": 414972.0, "GNPOld": 401461.0, "LocalName": "M\\u00e9xico", "GovernmentForm": "Federal Republic", "HeadOfState": "Vicente Fox Quesada", "Capital": 2515, "Code2": "MX"}, {"Code": "MHL", "Name": "Marshall Islands", "Continent": "Oceania", "Region": "Micronesia", "SurfaceArea": 181.0, "IndepYear": 1990, "Population": 64000, "LifeExpectancy": 65.5, "GNP": 97.0, "GNPOld": null, "LocalName": "Marshall Islands/Majol", "GovernmentForm": "Republic", "HeadOfState": "Kessai Note", "Capital": 2507, "Code2": "MH"}, {"Code": "MKD", "Name": "Macedonia", "Continent": "Europe", "Region": "Southern Europe", "SurfaceArea": 25713.0, "IndepYear": 1991, "Population": 2024000, "LifeExpectancy": 73.8, "GNP": 1694.0, "GNPOld": 1915.0, "LocalName": "Makedonija", "GovernmentForm": "Republic", "HeadOfState": "Boris Trajkovski", "Capital": 2460, "Code2": "MK"}, {"Code": "MLI", "Name": "Mali", "Continent": "Africa", "Region": "Western Africa", "SurfaceArea": 1240192.0, "IndepYear": 1960, "Population": 11234000, "LifeExpectancy": 46.7, "GNP": 2642.0, "GNPOld": 2453.0, "LocalName": "Mali", "GovernmentForm": "Republic", "HeadOfState": "Alpha Oumar Konar\\u00e9", "Capital": 2482, "Code2": "ML"}, {"Code": "MLT", "Name": "Malta", "Continent": "Europe", "Region": "Southern Europe", "SurfaceArea": 316.0, "IndepYear": 1964, "Population": 380200, "LifeExpectancy": 77.9, "GNP": 3512.0, "GNPOld": 3338.0, "LocalName": "Malta", "GovernmentForm": "Republic", "HeadOfState": "Guido de Marco", "Capital": 2484, "Code2": "MT"}, {"Code": "MMR", "Name": "Myanmar", "Continent": "Asia", "Region": "Southeast Asia", "SurfaceArea": 676578.0, "IndepYear": 1948, "Population": 45611000, "LifeExpectancy": 54.9, "GNP": 180375.0, "GNPOld": 171028.0, "LocalName": "Myanma Pye", "GovernmentForm": "Republic", "HeadOfState": "kenraali Than Shwe", "Capital": 2710, "Code2": "MM"}, {"Code": "MNG", "Name": "Mongolia", "Continent": "Asia", "Region": "Eastern Asia", "SurfaceArea": 1566500.0, "IndepYear": 1921, "Population": 2662000, "LifeExpectancy": 67.3, "GNP": 1043.0, "GNPOld": 933.0, "LocalName": "Mongol Uls", "GovernmentForm": "Republic", "HeadOfState": "Natsagiin Bagabandi", "Capital": 2696, "Code2": "MN"}, {"Code": "MNP", "Name": "Northern Mariana Islands", "Continent": "Oceania", "Region": "Micronesia", "SurfaceArea": 464.0, "IndepYear": null, "Population": 78000, "LifeExpectancy": 75.5, "GNP": 0.0, "GNPOld": null, "LocalName": "Northern Mariana Islands", "GovernmentForm": "Commonwealth of the US", "HeadOfState": "George W. Bush", "Capital": 2913, "Code2": "MP"}, {"Code": "MOZ", "Name": "Mozambique", "Continent": "Africa", "Region": "Eastern Africa", "SurfaceArea": 801590.0, "IndepYear": 1975, "Population": 19680000, "LifeExpectancy": 37.5, "GNP": 2891.0, "GNPOld": 2711.0, "LocalName": "Mo\\u00e7ambique", "GovernmentForm": "Republic", "HeadOfState": "Joaqu\\u00edm A. Chissano", "Capital": 2698, "Code2": "MZ"}, {"Code": "MRT", "Name": "Mauritania", "Continent": "Africa", "Region": "Western Africa", "SurfaceArea": 1025520.0, "IndepYear": 1960, "Population": 2670000, "LifeExpectancy": 50.8, "GNP": 998.0, "GNPOld": 1081.0, "LocalName": "Muritaniya/Mauritanie", "GovernmentForm": "Republic", "HeadOfState": "Maaouiya Ould Sid\\u00b4Ahmad Taya", "Capital": 2509, "Code2": "MR"}, {"Code": "MSR", "Name": "Montserrat", "Continent": "North America", "Region": "Caribbean", "SurfaceArea": 102.0, "IndepYear": null, "Population": 11000, "LifeExpectancy": 78.0, "GNP": 109.0, "GNPOld": null, "LocalName": "Montserrat", "GovernmentForm": "Dependent Territory of the UK", "HeadOfState": "Elisabeth II", "Capital": 2697, "Code2": "MS"}, {"Code": "MTQ", "Name": "Martinique", "Continent": "North America", "Region": "Caribbean", "SurfaceArea": 1102.0, "IndepYear": null, "Population": 395000, "LifeExpectancy": 78.3, "GNP": 2731.0, "GNPOld": 2559.0, "LocalName": "Martinique", "GovernmentForm": "Overseas Department of France", "HeadOfState": "Jacques Chirac", "Capital": 2508, "Code2": "MQ"}, {"Code": "MUS", "Name": "Mauritius", "Continent": "Africa", "Region": "Eastern Africa", "SurfaceArea": 2040.0, "IndepYear": 1968, "Population": 1158000, "LifeExpectancy": 71.0, "GNP": 4251.0, "GNPOld": 4186.0, "LocalName": "Mauritius", "GovernmentForm": "Republic", "HeadOfState": "Cassam Uteem", "Capital": 2511, "Code2": "MU"}, {"Code": "MWI", "Name": "Malawi", "Continent": "Africa", "Region": "Eastern Africa", "SurfaceArea": 118484.0, "IndepYear": 1964, "Population": 10925000, "LifeExpectancy": 37.6, "GNP": 1687.0, "GNPOld": 2527.0, "LocalName": "Malawi", "GovernmentForm": "Republic", "HeadOfState": "Bakili Muluzi", "Capital": 2462, "Code2": "MW"}, {"Code": "MYS", "Name": "Malaysia", "Continent": "Asia", "Region": "Southeast Asia", "SurfaceArea": 329758.0, "IndepYear": 1957, "Population": 22244000, "LifeExpectancy": 70.8, "GNP": 69213.0, "GNPOld": 97884.0, "LocalName": "Malaysia", "GovernmentForm": "Constitutional Monarchy, Federation", "HeadOfState": "Salahuddin Abdul Aziz Shah Alhaj", "Capital": 2464, "Code2": "MY"}, {"Code": "MYT", "Name": "Mayotte", "Continent": "Africa", "Region": "Eastern Africa", "SurfaceArea": 373.0, "IndepYear": null, "Population": 149000, "LifeExpectancy": 59.5, "GNP": 0.0, "GNPOld": null, "LocalName": "Mayotte", "GovernmentForm": "Territorial Collectivity of France", "HeadOfState": "Jacques Chirac", "Capital": 2514, "Code2": "YT"}, {"Code": "NAM", "Name": "Namibia", "Continent": "Africa", "Region": "Southern Africa", "SurfaceArea": 824292.0, "IndepYear": 1990, "Population": 1726000, "LifeExpectancy": 42.5, "GNP": 3101.0, "GNPOld": 3384.0, "LocalName": "Namibia", "GovernmentForm": "Republic", "HeadOfState": "Sam Nujoma", "Capital": 2726, "Code2": "NA"}, {"Code": "NCL", "Name": "New Caledonia", "Continent": "Oceania", "Region": "Melanesia", "SurfaceArea": 18575.0, "IndepYear": null, "Population": 214000, "LifeExpectancy": 72.8, "GNP": 3563.0, "GNPOld": null, "LocalName": "Nouvelle-Cal\\u00e9donie", "GovernmentForm": "Nonmetropolitan Territory of France", "HeadOfState": "Jacques Chirac", "Capital": 3493, "Code2": "NC"}, {"Code": "NER", "Name": "Niger", "Continent": "Africa", "Region": "Western Africa", "SurfaceArea": 1267000.0, "IndepYear": 1960, "Population": 10730000, "LifeExpectancy": 41.3, "GNP": 1706.0, "GNPOld": 1580.0, "LocalName": "Niger", "GovernmentForm": "Republic", "HeadOfState": "Mamadou Tandja", "Capital": 2738, "Code2": "NE"}, {"Code": "NFK", "Name": "Norfolk Island", "Continent": "Oceania", "Region": "Australia and New Zealand", "SurfaceArea": 36.0, "IndepYear": null, "Population": 2000, "LifeExpectancy": null, "GNP": 0.0, "GNPOld": null, "LocalName": "Norfolk Island", "GovernmentForm": "Territory of Australia", "HeadOfState": "Elisabeth II", "Capital": 2806, "Code2": "NF"}, {"Code": "NGA", "Name": "Nigeria", "Continent": "Africa", "Region": "Western Africa", "SurfaceArea": 923768.0, "IndepYear": 1960, "Population": 111506000, "LifeExpectancy": 51.6, "GNP": 65707.0, "GNPOld": 58623.0, "LocalName": "Nigeria", "GovernmentForm": "Federal Republic", "HeadOfState": "Olusegun Obasanjo", "Capital": 2754, "Code2": "NG"}, {"Code": "NIC", "Name": "Nicaragua", "Continent": "North America", "Region": "Central America", "SurfaceArea": 130000.0, "IndepYear": 1838, "Population": 5074000, "LifeExpectancy": 68.7, "GNP": 1988.0, "GNPOld": 2023.0, "LocalName": "Nicaragua", "GovernmentForm": "Republic", "HeadOfState": "Arnoldo Alem\\u00e1n Lacayo", "Capital": 2734, "Code2": "NI"}, {"Code": "NIU", "Name": "Niue", "Continent": "Oceania", "Region": "Polynesia", "SurfaceArea": 260.0, "IndepYear": null, "Population": 2000, "LifeExpectancy": null, "GNP": 0.0, "GNPOld": null, "LocalName": "Niue", "GovernmentForm": "Nonmetropolitan Territory of New Zealand", "HeadOfState": "Elisabeth II", "Capital": 2805, "Code2": "NU"}, {"Code": "NLD", "Name": "Netherlands", "Continent": "Europe", "Region": "Western Europe", "SurfaceArea": 41526.0, "IndepYear": 1581, "Population": 15864000, "LifeExpectancy": 78.3, "GNP": 371362.0, "GNPOld": 360478.0, "LocalName": "Nederland", "GovernmentForm": "Constitutional Monarchy", "HeadOfState": "Beatrix", "Capital": 5, "Code2": "NL"}, {"Code": "NOR", "Name": "Norway", "Continent": "Europe", "Region": "Nordic Countries", "SurfaceArea": 323877.0, "IndepYear": 1905, "Population": 4478500, "LifeExpectancy": 78.7, "GNP": 145895.0, "GNPOld": 153370.0, "LocalName": "Norge", "GovernmentForm": "Constitutional Monarchy", "HeadOfState": "Harald V", "Capital": 2807, "Code2": "NO"}, {"Code": "NPL", "Name": "Nepal", "Continent": "Asia", "Region": "Southern and Central Asia", "SurfaceArea": 147181.0, "IndepYear": 1769, "Population": 23930000, "LifeExpectancy": 57.8, "GNP": 4768.0, "GNPOld": 4837.0, "LocalName": "Nepal", "GovernmentForm": "Constitutional Monarchy", "HeadOfState": "Gyanendra Bir Bikram", "Capital": 2729, "Code2": "NP"}, {"Code": "NRU", "Name": "Nauru", "Continent": "Oceania", "Region": "Micronesia", "SurfaceArea": 21.0, "IndepYear": 1968, "Population": 12000, "LifeExpectancy": 60.8, "GNP": 197.0, "GNPOld": null, "LocalName": "Naoero/Nauru", "GovernmentForm": "Republic", "HeadOfState": "Bernard Dowiyogo", "Capital": 2728, "Code2": "NR"}, {"Code": "NZL", "Name": "New Zealand", "Continent": "Oceania", "Region": "Australia and New Zealand", "SurfaceArea": 270534.0, "IndepYear": 1907, "Population": 3862000, "LifeExpectancy": 77.8, "GNP": 54669.0, "GNPOld": 64960.0, "LocalName": "New Zealand/Aotearoa", "GovernmentForm": "Constitutional Monarchy", "HeadOfState": "Elisabeth II", "Capital": 3499, "Code2": "NZ"}, {"Code": "OMN", "Name": "Oman", "Continent": "Asia", "Region": "Middle East", "SurfaceArea": 309500.0, "IndepYear": 1951, "Population": 2542000, "LifeExpectancy": 71.8, "GNP": 16904.0, "GNPOld": 16153.0, "LocalName": "\\u00b4Uman", "GovernmentForm": "Monarchy (Sultanate)", "HeadOfState": "Qabus ibn Sa\\u00b4id", "Capital": 2821, "Code2": "OM"}, {"Code": "PAK", "Name": "Pakistan", "Continent": "Asia", "Region": "Southern and Central Asia", "SurfaceArea": 796095.0, "IndepYear": 1947, "Population": 156483000, "LifeExpectancy": 61.1, "GNP": 61289.0, "GNPOld": 58549.0, "LocalName": "Pakistan", "GovernmentForm": "Republic", "HeadOfState": "Mohammad Rafiq Tarar", "Capital": 2831, "Code2": "PK"}, {"Code": "PAN", "Name": "Panama", "Continent": "North America", "Region": "Central America", "SurfaceArea": 75517.0, "IndepYear": 1903, "Population": 2856000, "LifeExpectancy": 75.5, "GNP": 9131.0, "GNPOld": 8700.0, "LocalName": "Panam\\u00e1", "GovernmentForm": "Republic", "HeadOfState": "Mireya Elisa Moscoso Rodr\\u00edguez", "Capital": 2882, "Code2": "PA"}, {"Code": "PCN", "Name": "Pitcairn", "Continent": "Oceania", "Region": "Polynesia", "SurfaceArea": 49.0, "IndepYear": null, "Population": 50, "LifeExpectancy": null, "GNP": 0.0, "GNPOld": null, "LocalName": "Pitcairn", "GovernmentForm": "Dependent Territory of the UK", "HeadOfState": "Elisabeth II", "Capital": 2912, "Code2": "PN"}, {"Code": "PER", "Name": "Peru", "Continent": "South America", "Region": "South America", "SurfaceArea": 1285216.0, "IndepYear": 1821, "Population": 25662000, "LifeExpectancy": 70.0, "GNP": 64140.0, "GNPOld": 65186.0, "LocalName": "Per\\u00fa/Piruw", "GovernmentForm": "Republic", "HeadOfState": "Valentin Paniagua Corazao", "Capital": 2890, "Code2": "PE"}, {"Code": "PHL", "Name": "Philippines", "Continent": "Asia", "Region": "Southeast Asia", "SurfaceArea": 300000.0, "IndepYear": 1946, "Population": 75967000, "LifeExpectancy": 67.5, "GNP": 65107.0, "GNPOld": 82239.0, "LocalName": "Pilipinas", "GovernmentForm": "Republic", "HeadOfState": "Gloria Macapagal-Arroyo", "Capital": 766, "Code2": "PH"}, {"Code": "PLW", "Name": "Palau", "Continent": "Oceania", "Region": "Micronesia", "SurfaceArea": 459.0, "IndepYear": 1994, "Population": 19000, "LifeExpectancy": 68.6, "GNP": 105.0, "GNPOld": null, "LocalName": "Belau/Palau", "GovernmentForm": "Republic", "HeadOfState": "Kuniwo Nakamura", "Capital": 2881, "Code2": "PW"}, {"Code": "PNG", "Name": "Papua New Guinea", "Continent": "Oceania", "Region": "Melanesia", "SurfaceArea": 462840.0, "IndepYear": 1975, "Population": 4807000, "LifeExpectancy": 63.1, "GNP": 4988.0, "GNPOld": 6328.0, "LocalName": "Papua New Guinea/Papua Niugini", "GovernmentForm": "Constitutional Monarchy", "HeadOfState": "Elisabeth II", "Capital": 2884, "Code2": "PG"}, {"Code": "POL", "Name": "Poland", "Continent": "Europe", "Region": "Eastern Europe", "SurfaceArea": 323250.0, "IndepYear": 1918, "Population": 38653600, "LifeExpectancy": 73.2, "GNP": 151697.0, "GNPOld": 135636.0, "LocalName": "Polska", "GovernmentForm": "Republic", "HeadOfState": "Aleksander Kwasniewski", "Capital": 2928, "Code2": "PL"}, {"Code": "PRI", "Name": "Puerto Rico", "Continent": "North America", "Region": "Caribbean", "SurfaceArea": 8875.0, "IndepYear": null, "Population": 3869000, "LifeExpectancy": 75.6, "GNP": 34100.0, "GNPOld": 32100.0, "LocalName": "Puerto Rico", "GovernmentForm": "Commonwealth of the US", "HeadOfState": "George W. Bush", "Capital": 2919, "Code2": "PR"}, {"Code": "PRK", "Name": "North Korea", "Continent": "Asia", "Region": "Eastern Asia", "SurfaceArea": 120538.0, "IndepYear": 1948, "Population": 24039000, "LifeExpectancy": 70.7, "GNP": 5332.0, "GNPOld": null, "LocalName": "Choson Minjujuui In\\u00b4min Konghwaguk (Bukhan)", "GovernmentForm": "Socialistic Republic", "HeadOfState": "Kim Jong-il", "Capital": 2318, "Code2": "KP"}, {"Code": "PRT", "Name": "Portugal", "Continent": "Europe", "Region": "Southern Europe", "SurfaceArea": 91982.0, "IndepYear": 1143, "Population": 9997600, "LifeExpectancy": 75.8, "GNP": 105954.0, "GNPOld": 102133.0, "LocalName": "Portugal", "GovernmentForm": "Republic", "HeadOfState": "Jorge Samp\\u00e3io", "Capital": 2914, "Code2": "PT"}, {"Code": "PRY", "Name": "Paraguay", "Continent": "South America", "Region": "South America", "SurfaceArea": 406752.0, "IndepYear": 1811, "Population": 5496000, "LifeExpectancy": 73.7, "GNP": 8444.0, "GNPOld": 9555.0, "LocalName": "Paraguay", "GovernmentForm": "Republic", "HeadOfState": "Luis \\u00c1ngel Gonz\\u00e1lez Macchi", "Capital": 2885, "Code2": "PY"}, {"Code": "PSE", "Name": "Palestine", "Continent": "Asia", "Region": "Middle East", "SurfaceArea": 6257.0, "IndepYear": null, "Population": 3101000, "LifeExpectancy": 71.4, "GNP": 4173.0, "GNPOld": null, "LocalName": "Filastin", "GovernmentForm": "Autonomous Area", "HeadOfState": "Yasser (Yasir) Arafat", "Capital": 4074, "Code2": "PS"}, {"Code": "PYF", "Name": "French Polynesia", "Continent": "Oceania", "Region": "Polynesia", "SurfaceArea": 4000.0, "IndepYear": null, "Population": 235000, "LifeExpectancy": 74.8, "GNP": 818.0, "GNPOld": 781.0, "LocalName": "Polyn\\u00e9sie fran\\u00e7aise", "GovernmentForm": "Nonmetropolitan Territory of France", "HeadOfState": "Jacques Chirac", "Capital": 3016, "Code2": "PF"}, {"Code": "QAT", "Name": "Qatar", "Continent": "Asia", "Region": "Middle East", "SurfaceArea": 11000.0, "IndepYear": 1971, "Population": 599000, "LifeExpectancy": 72.4, "GNP": 9472.0, "GNPOld": 8920.0, "LocalName": "Qatar", "GovernmentForm": "Monarchy", "HeadOfState": "Hamad ibn Khalifa al-Thani", "Capital": 2973, "Code2": "QA"}, {"Code": "REU", "Name": "R\\u00e9union", "Continent": "Africa", "Region": "Eastern Africa", "SurfaceArea": 2510.0, "IndepYear": null, "Population": 699000, "LifeExpectancy": 72.7, "GNP": 8287.0, "GNPOld": 7988.0, "LocalName": "R\\u00e9union", "GovernmentForm": "Overseas Department of France", "HeadOfState": "Jacques Chirac", "Capital": 3017, "Code2": "RE"}, {"Code": "ROM", "Name": "Romania", "Continent": "Europe", "Region": "Eastern Europe", "SurfaceArea": 238391.0, "IndepYear": 1878, "Population": 22455500, "LifeExpectancy": 69.9, "GNP": 38158.0, "GNPOld": 34843.0, "LocalName": "Rom\\u00e2nia", "GovernmentForm": "Republic", "HeadOfState": "Ion Iliescu", "Capital": 3018, "Code2": "RO"}, {"Code": "RUS", "Name": "Russian Federation", "Continent": "Europe", "Region": "Eastern Europe", "SurfaceArea": 17075400.0, "IndepYear": 1991, "Population": 146934000, "LifeExpectancy": 67.2, "GNP": 276608.0, "GNPOld": 442989.0, "LocalName": "Rossija", "GovernmentForm": "Federal Republic", "HeadOfState": "Vladimir Putin", "Capital": 3580, "Code2": "RU"}, {"Code": "RWA", "Name": "Rwanda", "Continent": "Africa", "Region": "Eastern Africa", "SurfaceArea": 26338.0, "IndepYear": 1962, "Population": 7733000, "LifeExpectancy": 39.3, "GNP": 2036.0, "GNPOld": 1863.0, "LocalName": "Rwanda/Urwanda", "GovernmentForm": "Republic", "HeadOfState": "Paul Kagame", "Capital": 3047, "Code2": "RW"}, {"Code": "SAU", "Name": "Saudi Arabia", "Continent": "Asia", "Region": "Middle East", "SurfaceArea": 2149690.0, "IndepYear": 1932, "Population": 21607000, "LifeExpectancy": 67.8, "GNP": 137635.0, "GNPOld": 146171.0, "LocalName": "Al-\\u00b4Arabiya as-Sa\\u00b4udiya", "GovernmentForm": "Monarchy", "HeadOfState": "Fahd ibn Abdul-Aziz al-Sa\\u00b4ud", "Capital": 3173, "Code2": "SA"}, {"Code": "SDN", "Name": "Sudan", "Continent": "Africa", "Region": "Northern Africa", "SurfaceArea": 2505813.0, "IndepYear": 1956, "Population": 29490000, "LifeExpectancy": 56.6, "GNP": 10162.0, "GNPOld": null, "LocalName": "As-Sudan", "GovernmentForm": "Islamic Republic", "HeadOfState": "Omar Hassan Ahmad al-Bashir", "Capital": 3225, "Code2": "SD"}, {"Code": "SEN", "Name": "Senegal", "Continent": "Africa", "Region": "Western Africa", "SurfaceArea": 196722.0, "IndepYear": 1960, "Population": 9481000, "LifeExpectancy": 62.2, "GNP": 4787.0, "GNPOld": 4542.0, "LocalName": "S\\u00e9n\\u00e9gal/Sounougal", "GovernmentForm": "Republic", "HeadOfState": "Abdoulaye Wade", "Capital": 3198, "Code2": "SN"}, {"Code": "SGP", "Name": "Singapore", "Continent": "Asia", "Region": "Southeast Asia", "SurfaceArea": 618.0, "IndepYear": 1965, "Population": 3567000, "LifeExpectancy": 80.1, "GNP": 86503.0, "GNPOld": 96318.0, "LocalName": "Singapore/Singapura/Xinjiapo/Singapur", "GovernmentForm": "Republic", "HeadOfState": "Sellapan Rama Nathan", "Capital": 3208, "Code2": "SG"}, {"Code": "SGS", "Name": "South Georgia and the South Sandwich Islands", "Continent": "Antarctica", "Region": "Antarctica", "SurfaceArea": 3903.0, "IndepYear": null, "Population": 0, "LifeExpectancy": null, "GNP": 0.0, "GNPOld": null, "LocalName": "South Georgia and the South Sandwich Islands", "GovernmentForm": "Dependent Territory of the UK", "HeadOfState": "Elisabeth II", "Capital": null, "Code2": "GS"}, {"Code": "SHN", "Name": "Saint Helena", "Continent": "Africa", "Region": "Western Africa", "SurfaceArea": 314.0, "IndepYear": null, "Population": 6000, "LifeExpectancy": 76.8, "GNP": 0.0, "GNPOld": null, "LocalName": "Saint Helena", "GovernmentForm": "Dependent Territory of the UK", "HeadOfState": "Elisabeth II", "Capital": 3063, "Code2": "SH"}, {"Code": "SJM", "Name": "Svalbard and Jan Mayen", "Continent": "Europe", "Region": "Nordic Countries", "SurfaceArea": 62422.0, "IndepYear": null, "Population": 3200, "LifeExpectancy": null, "GNP": 0.0, "GNPOld": null, "LocalName": "Svalbard og Jan Mayen", "GovernmentForm": "Dependent Territory of Norway", "HeadOfState": "Harald V", "Capital": 938, "Code2": "SJ"}, {"Code": "SLB", "Name": "Solomon Islands", "Continent": "Oceania", "Region": "Melanesia", "SurfaceArea": 28896.0, "IndepYear": 1978, "Population": 444000, "LifeExpectancy": 71.3, "GNP": 182.0, "GNPOld": 220.0, "LocalName": "Solomon Islands", "GovernmentForm": "Constitutional Monarchy", "HeadOfState": "Elisabeth II", "Capital": 3161, "Code2": "SB"}, {"Code": "SLE", "Name": "Sierra Leone", "Continent": "Africa", "Region": "Western Africa", "SurfaceArea": 71740.0, "IndepYear": 1961, "Population": 4854000, "LifeExpectancy": 45.3, "GNP": 746.0, "GNPOld": 858.0, "LocalName": "Sierra Leone", "GovernmentForm": "Republic", "HeadOfState": "Ahmed Tejan Kabbah", "Capital": 3207, "Code2": "SL"}, {"Code": "SLV", "Name": "El Salvador", "Continent": "North America", "Region": "Central America", "SurfaceArea": 21041.0, "IndepYear": 1841, "Population": 6276000, "LifeExpectancy": 69.7, "GNP": 11863.0, "GNPOld": 11203.0, "LocalName": "El Salvador", "GovernmentForm": "Republic", "HeadOfState": "Francisco Guillermo Flores P\\u00e9rez", "Capital": 645, "Code2": "SV"}, {"Code": "SMR", "Name": "San Marino", "Continent": "Europe", "Region": "Southern Europe", "SurfaceArea": 61.0, "IndepYear": 885, "Population": 27000, "LifeExpectancy": 81.1, "GNP": 510.0, "GNPOld": null, "LocalName": "San Marino", "GovernmentForm": "Republic", "HeadOfState": null, "Capital": 3171, "Code2": "SM"}, {"Code": "SOM", "Name": "Somalia", "Continent": "Africa", "Region": "Eastern Africa", "SurfaceArea": 637657.0, "IndepYear": 1960, "Population": 10097000, "LifeExpectancy": 46.2, "GNP": 935.0, "GNPOld": null, "LocalName": "Soomaaliya", "GovernmentForm": "Republic", "HeadOfState": "Abdiqassim Salad Hassan", "Capital": 3214, "Code2": "SO"}, {"Code": "SPM", "Name": "Saint Pierre and Miquelon", "Continent": "North America", "Region": "North America", "SurfaceArea": 242.0, "IndepYear": null, "Population": 7000, "LifeExpectancy": 77.6, "GNP": 0.0, "GNPOld": null, "LocalName": "Saint-Pierre-et-Miquelon", "GovernmentForm": "Territorial Collectivity of France", "HeadOfState": "Jacques Chirac", "Capital": 3067, "Code2": "PM"}, {"Code": "STP", "Name": "Sao Tome and Principe", "Continent": "Africa", "Region": "Central Africa", "SurfaceArea": 964.0, "IndepYear": 1975, "Population": 147000, "LifeExpectancy": 65.3, "GNP": 6.0, "GNPOld": null, "LocalName": "S\\u00e3o Tom\\u00e9 e Pr\\u00edncipe", "GovernmentForm": "Republic", "HeadOfState": "Miguel Trovoada", "Capital": 3172, "Code2": "ST"}, {"Code": "SUR", "Name": "Suriname", "Continent": "South America", "Region": "South America", "SurfaceArea": 163265.0, "IndepYear": 1975, "Population": 417000, "LifeExpectancy": 71.4, "GNP": 870.0, "GNPOld": 706.0, "LocalName": "Suriname", "GovernmentForm": "Republic", "HeadOfState": "Ronald Venetiaan", "Capital": 3243, "Code2": "SR"}, {"Code": "SVK", "Name": "Slovakia", "Continent": "Europe", "Region": "Eastern Europe", "SurfaceArea": 49012.0, "IndepYear": 1993, "Population": 5398700, "LifeExpectancy": 73.7, "GNP": 20594.0, "GNPOld": 19452.0, "LocalName": "Slovensko", "GovernmentForm": "Republic", "HeadOfState": "Rudolf Schuster", "Capital": 3209, "Code2": "SK"}, {"Code": "SVN", "Name": "Slovenia", "Continent": "Europe", "Region": "Southern Europe", "SurfaceArea": 20256.0, "IndepYear": 1991, "Population": 1987800, "LifeExpectancy": 74.9, "GNP": 19756.0, "GNPOld": 18202.0, "LocalName": "Slovenija", "GovernmentForm": "Republic", "HeadOfState": "Milan Kucan", "Capital": 3212, "Code2": "SI"}, {"Code": "SWE", "Name": "Sweden", "Continent": "Europe", "Region": "Nordic Countries", "SurfaceArea": 449964.0, "IndepYear": 836, "Population": 8861400, "LifeExpectancy": 79.6, "GNP": 226492.0, "GNPOld": 227757.0, "LocalName": "Sverige", "GovernmentForm": "Constitutional Monarchy", "HeadOfState": "Carl XVI Gustaf", "Capital": 3048, "Code2": "SE"}, {"Code": "SWZ", "Name": "Swaziland", "Continent": "Africa", "Region": "Southern Africa", "SurfaceArea": 17364.0, "IndepYear": 1968, "Population": 1008000, "LifeExpectancy": 40.4, "GNP": 1206.0, "GNPOld": 1312.0, "LocalName": "kaNgwane", "GovernmentForm": "Monarchy", "HeadOfState": "Mswati III", "Capital": 3244, "Code2": "SZ"}, {"Code": "SYC", "Name": "Seychelles", "Continent": "Africa", "Region": "Eastern Africa", "SurfaceArea": 455.0, "IndepYear": 1976, "Population": 77000, "LifeExpectancy": 70.4, "GNP": 536.0, "GNPOld": 539.0, "LocalName": "Sesel/Seychelles", "GovernmentForm": "Republic", "HeadOfState": "France-Albert Ren\\u00e9", "Capital": 3206, "Code2": "SC"}, {"Code": "SYR", "Name": "Syria", "Continent": "Asia", "Region": "Middle East", "SurfaceArea": 185180.0, "IndepYear": 1941, "Population": 16125000, "LifeExpectancy": 68.5, "GNP": 65984.0, "GNPOld": 64926.0, "LocalName": "Suriya", "GovernmentForm": "Republic", "HeadOfState": "Bashar al-Assad", "Capital": 3250, "Code2": "SY"}, {"Code": "TCA", "Name": "Turks and Caicos Islands", "Continent": "North America", "Region": "Caribbean", "SurfaceArea": 430.0, "IndepYear": null, "Population": 17000, "LifeExpectancy": 73.3, "GNP": 96.0, "GNPOld": null, "LocalName": "The Turks and Caicos Islands", "GovernmentForm": "Dependent Territory of the UK", "HeadOfState": "Elisabeth II", "Capital": 3423, "Code2": "TC"}, {"Code": "TCD", "Name": "Chad", "Continent": "Africa", "Region": "Central Africa", "SurfaceArea": 1284000.0, "IndepYear": 1960, "Population": 7651000, "LifeExpectancy": 50.5, "GNP": 1208.0, "GNPOld": 1102.0, "LocalName": "Tchad/Tshad", "GovernmentForm": "Republic", "HeadOfState": "Idriss D\\u00e9by", "Capital": 3337, "Code2": "TD"}, {"Code": "TGO", "Name": "Togo", "Continent": "Africa", "Region": "Western Africa", "SurfaceArea": 56785.0, "IndepYear": 1960, "Population": 4629000, "LifeExpectancy": 54.7, "GNP": 1449.0, "GNPOld": 1400.0, "LocalName": "Togo", "GovernmentForm": "Republic", "HeadOfState": "Gnassingb\\u00e9 Eyad\\u00e9ma", "Capital": 3332, "Code2": "TG"}, {"Code": "THA", "Name": "Thailand", "Continent": "Asia", "Region": "Southeast Asia", "SurfaceArea": 513115.0, "IndepYear": 1350, "Population": 61399000, "LifeExpectancy": 68.6, "GNP": 116416.0, "GNPOld": 153907.0, "LocalName": "Prathet Thai", "GovernmentForm": "Constitutional Monarchy", "HeadOfState": "Bhumibol Adulyadej", "Capital": 3320, "Code2": "TH"}, {"Code": "TJK", "Name": "Tajikistan", "Continent": "Asia", "Region": "Southern and Central Asia", "SurfaceArea": 143100.0, "IndepYear": 1991, "Population": 6188000, "LifeExpectancy": 64.1, "GNP": 1990.0, "GNPOld": 1056.0, "LocalName": "To\\u00e7ikiston", "GovernmentForm": "Republic", "HeadOfState": "Emomali Rahmonov", "Capital": 3261, "Code2": "TJ"}, {"Code": "TKL", "Name": "Tokelau", "Continent": "Oceania", "Region": "Polynesia", "SurfaceArea": 12.0, "IndepYear": null, "Population": 2000, "LifeExpectancy": null, "GNP": 0.0, "GNPOld": null, "LocalName": "Tokelau", "GovernmentForm": "Nonmetropolitan Territory of New Zealand", "HeadOfState": "Elisabeth II", "Capital": 3333, "Code2": "TK"}, {"Code": "TKM", "Name": "Turkmenistan", "Continent": "Asia", "Region": "Southern and Central Asia", "SurfaceArea": 488100.0, "IndepYear": 1991, "Population": 4459000, "LifeExpectancy": 60.9, "GNP": 4397.0, "GNPOld": 2000.0, "LocalName": "T\\u00fcrkmenostan", "GovernmentForm": "Republic", "HeadOfState": "Saparmurad Nijazov", "Capital": 3419, "Code2": "TM"}, {"Code": "TMP", "Name": "East Timor", "Continent": "Asia", "Region": "Southeast Asia", "SurfaceArea": 14874.0, "IndepYear": null, "Population": 885000, "LifeExpectancy": 46.0, "GNP": 0.0, "GNPOld": null, "LocalName": "Timor Timur", "GovernmentForm": "Administrated by the UN", "HeadOfState": "Jos\\u00e9 Alexandre Gusm\\u00e3o", "Capital": 1522, "Code2": "TP"}, {"Code": "TON", "Name": "Tonga", "Continent": "Oceania", "Region": "Polynesia", "SurfaceArea": 650.0, "IndepYear": 1970, "Population": 99000, "LifeExpectancy": 67.9, "GNP": 146.0, "GNPOld": 170.0, "LocalName": "Tonga", "GovernmentForm": "Monarchy", "HeadOfState": "Taufa'ahau Tupou IV", "Capital": 3334, "Code2": "TO"}, {"Code": "TTO", "Name": "Trinidad and Tobago", "Continent": "North America", "Region": "Caribbean", "SurfaceArea": 5130.0, "IndepYear": 1962, "Population": 1295000, "LifeExpectancy": 68.0, "GNP": 6232.0, "GNPOld": 5867.0, "LocalName": "Trinidad and Tobago", "GovernmentForm": "Republic", "HeadOfState": "Arthur N. R. Robinson", "Capital": 3336, "Code2": "TT"}, {"Code": "TUN", "Name": "Tunisia", "Continent": "Africa", "Region": "Northern Africa", "SurfaceArea": 163610.0, "IndepYear": 1956, "Population": 9586000, "LifeExpectancy": 73.7, "GNP": 20026.0, "GNPOld": 18898.0, "LocalName": "Tunis/Tunisie", "GovernmentForm": "Republic", "HeadOfState": "Zine al-Abidine Ben Ali", "Capital": 3349, "Code2": "TN"}, {"Code": "TUR", "Name": "Turkey", "Continent": "Asia", "Region": "Middle East", "SurfaceArea": 774815.0, "IndepYear": 1923, "Population": 66591000, "LifeExpectancy": 71.0, "GNP": 210721.0, "GNPOld": 189122.0, "LocalName": "T\\u00fcrkiye", "GovernmentForm": "Republic", "HeadOfState": "Ahmet Necdet Sezer", "Capital": 3358, "Code2": "TR"}, {"Code": "TUV", "Name": "Tuvalu", "Continent": "Oceania", "Region": "Polynesia", "SurfaceArea": 26.0, "IndepYear": 1978, "Population": 12000, "LifeExpectancy": 66.3, "GNP": 6.0, "GNPOld": null, "LocalName": "Tuvalu", "GovernmentForm": "Constitutional Monarchy", "HeadOfState": "Elisabeth II", "Capital": 3424, "Code2": "TV"}, {"Code": "TWN", "Name": "Taiwan", "Continent": "Asia", "Region": "Eastern Asia", "SurfaceArea": 36188.0, "IndepYear": 1945, "Population": 22256000, "LifeExpectancy": 76.4, "GNP": 256254.0, "GNPOld": 263451.0, "LocalName": "T\\u2019ai-wan", "GovernmentForm": "Republic", "HeadOfState": "Chen Shui-bian", "Capital": 3263, "Code2": "TW"}, {"Code": "TZA", "Name": "Tanzania", "Continent": "Africa", "Region": "Eastern Africa", "SurfaceArea": 883749.0, "IndepYear": 1961, "Population": 33517000, "LifeExpectancy": 52.3, "GNP": 8005.0, "GNPOld": 7388.0, "LocalName": "Tanzania", "GovernmentForm": "Republic", "HeadOfState": "Benjamin William Mkapa", "Capital": 3306, "Code2": "TZ"}, {"Code": "UGA", "Name": "Uganda", "Continent": "Africa", "Region": "Eastern Africa", "SurfaceArea": 241038.0, "IndepYear": 1962, "Population": 21778000, "LifeExpectancy": 42.9, "GNP": 6313.0, "GNPOld": 6887.0, "LocalName": "Uganda", "GovernmentForm": "Republic", "HeadOfState": "Yoweri Museveni", "Capital": 3425, "Code2": "UG"}, {"Code": "UKR", "Name": "Ukraine", "Continent": "Europe", "Region": "Eastern Europe", "SurfaceArea": 603700.0, "IndepYear": 1991, "Population": 50456000, "LifeExpectancy": 66.0, "GNP": 42168.0, "GNPOld": 49677.0, "LocalName": "Ukrajina", "GovernmentForm": "Republic", "HeadOfState": "Leonid Kut\\u0161ma", "Capital": 3426, "Code2": "UA"}, {"Code": "UMI", "Name": "United States Minor Outlying Islands", "Continent": "Oceania", "Region": "Micronesia/Caribbean", "SurfaceArea": 16.0, "IndepYear": null, "Population": 0, "LifeExpectancy": null, "GNP": 0.0, "GNPOld": null, "LocalName": "United States Minor Outlying Islands", "GovernmentForm": "Dependent Territory of the US", "HeadOfState": "George W. Bush", "Capital": null, "Code2": "UM"}, {"Code": "URY", "Name": "Uruguay", "Continent": "South America", "Region": "South America", "SurfaceArea": 175016.0, "IndepYear": 1828, "Population": 3337000, "LifeExpectancy": 75.2, "GNP": 20831.0, "GNPOld": 19967.0, "LocalName": "Uruguay", "GovernmentForm": "Republic", "HeadOfState": "Jorge Batlle Ib\\u00e1\\u00f1ez", "Capital": 3492, "Code2": "UY"}, {"Code": "USA", "Name": "United States", "Continent": "North America", "Region": "North America", "SurfaceArea": 9363520.0, "IndepYear": 1776, "Population": 278357000, "LifeExpectancy": 77.1, "GNP": 8510700.0, "GNPOld": 8110900.0, "LocalName": "United States", "GovernmentForm": "Federal Republic", "HeadOfState": "George W. Bush", "Capital": 3813, "Code2": "US"}, {"Code": "UZB", "Name": "Uzbekistan", "Continent": "Asia", "Region": "Southern and Central Asia", "SurfaceArea": 447400.0, "IndepYear": 1991, "Population": 24318000, "LifeExpectancy": 63.7, "GNP": 14194.0, "GNPOld": 21300.0, "LocalName": "Uzbekiston", "GovernmentForm": "Republic", "HeadOfState": "Islam Karimov", "Capital": 3503, "Code2": "UZ"}, {"Code": "VAT", "Name": "Holy See (Vatican City State)", "Continent": "Europe", "Region": "Southern Europe", "SurfaceArea": 0.4, "IndepYear": 1929, "Population": 1000, "LifeExpectancy": null, "GNP": 9.0, "GNPOld": null, "LocalName": "Santa Sede/Citt\\u00e0 del Vaticano", "GovernmentForm": "Independent Church State", "HeadOfState": "Johannes Paavali II", "Capital": 3538, "Code2": "VA"}, {"Code": "VCT", "Name": "Saint Vincent and the Grenadines", "Continent": "North America", "Region": "Caribbean", "SurfaceArea": 388.0, "IndepYear": 1979, "Population": 114000, "LifeExpectancy": 72.3, "GNP": 285.0, "GNPOld": null, "LocalName": "Saint Vincent and the Grenadines", "GovernmentForm": "Constitutional Monarchy", "HeadOfState": "Elisabeth II", "Capital": 3066, "Code2": "VC"}, {"Code": "VEN", "Name": "Venezuela", "Continent": "South America", "Region": "South America", "SurfaceArea": 912050.0, "IndepYear": 1811, "Population": 24170000, "LifeExpectancy": 73.1, "GNP": 95023.0, "GNPOld": 88434.0, "LocalName": "Venezuela", "GovernmentForm": "Federal Republic", "HeadOfState": "Hugo Ch\\u00e1vez Fr\\u00edas", "Capital": 3539, "Code2": "VE"}, {"Code": "VGB", "Name": "Virgin Islands, British", "Continent": "North America", "Region": "Caribbean", "SurfaceArea": 151.0, "IndepYear": null, "Population": 21000, "LifeExpectancy": 75.4, "GNP": 612.0, "GNPOld": 573.0, "LocalName": "British Virgin Islands", "GovernmentForm": "Dependent Territory of the UK", "HeadOfState": "Elisabeth II", "Capital": 537, "Code2": "VG"}, {"Code": "VIR", "Name": "Virgin Islands, U.S.", "Continent": "North America", "Region": "Caribbean", "SurfaceArea": 347.0, "IndepYear": null, "Population": 93000, "LifeExpectancy": 78.1, "GNP": 0.0, "GNPOld": null, "LocalName": "Virgin Islands of the United States", "GovernmentForm": "US Territory", "HeadOfState": "George W. Bush", "Capital": 4067, "Code2": "VI"}, {"Code": "VNM", "Name": "Vietnam", "Continent": "Asia", "Region": "Southeast Asia", "SurfaceArea": 331689.0, "IndepYear": 1945, "Population": 79832000, "LifeExpectancy": 69.3, "GNP": 21929.0, "GNPOld": 22834.0, "LocalName": "Vi\\u00eat Nam", "GovernmentForm": "Socialistic Republic", "HeadOfState": "Tr\\u00e2n Duc Luong", "Capital": 3770, "Code2": "VN"}, {"Code": "VUT", "Name": "Vanuatu", "Continent": "Oceania", "Region": "Melanesia", "SurfaceArea": 12189.0, "IndepYear": 1980, "Population": 190000, "LifeExpectancy": 60.6, "GNP": 261.0, "GNPOld": 246.0, "LocalName": "Vanuatu", "GovernmentForm": "Republic", "HeadOfState": "John Bani", "Capital": 3537, "Code2": "VU"}, {"Code": "WLF", "Name": "Wallis and Futuna", "Continent": "Oceania", "Region": "Polynesia", "SurfaceArea": 200.0, "IndepYear": null, "Population": 15000, "LifeExpectancy": null, "GNP": 0.0, "GNPOld": null, "LocalName": "Wallis-et-Futuna", "GovernmentForm": "Nonmetropolitan Territory of France", "HeadOfState": "Jacques Chirac", "Capital": 3536, "Code2": "WF"}, {"Code": "WSM", "Name": "Samoa", "Continent": "Oceania", "Region": "Polynesia", "SurfaceArea": 2831.0, "IndepYear": 1962, "Population": 180000, "LifeExpectancy": 69.2, "GNP": 141.0, "GNPOld": 157.0, "LocalName": "Samoa", "GovernmentForm": "Parlementary Monarchy", "HeadOfState": "Malietoa Tanumafili II", "Capital": 3169, "Code2": "WS"}, {"Code": "YEM", "Name": "Yemen", "Continent": "Asia", "Region": "Middle East", "SurfaceArea": 527968.0, "IndepYear": 1918, "Population": 18112000, "LifeExpectancy": 59.8, "GNP": 6041.0, "GNPOld": 5729.0, "LocalName": "Al-Yaman", "GovernmentForm": "Republic", "HeadOfState": "Ali Abdallah Salih", "Capital": 1780, "Code2": "YE"}, {"Code": "YUG", "Name": "Yugoslavia", "Continent": "Europe", "Region": "Southern Europe", "SurfaceArea": 102173.0, "IndepYear": 1918, "Population": 10640000, "LifeExpectancy": 72.4, "GNP": 17000.0, "GNPOld": null, "LocalName": "Jugoslavija", "GovernmentForm": "Federal Republic", "HeadOfState": "Vojislav Ko\\u0161tunica", "Capital": 1792, "Code2": "YU"}, {"Code": "ZAF", "Name": "South Africa", "Continent": "Africa", "Region": "Southern Africa", "SurfaceArea": 1221037.0, "IndepYear": 1910, "Population": 40377000, "LifeExpectancy": 51.1, "GNP": 116729.0, "GNPOld": 129092.0, "LocalName": "South Africa", "GovernmentForm": "Republic", "HeadOfState": "Thabo Mbeki", "Capital": 716, "Code2": "ZA"}, {"Code": "ZMB", "Name": "Zambia", "Continent": "Africa", "Region": "Eastern Africa", "SurfaceArea": 752618.0, "IndepYear": 1964, "Population": 9169000, "LifeExpectancy": 37.2, "GNP": 3377.0, "GNPOld": 3922.0, "LocalName": "Zambia", "GovernmentForm": "Republic", "HeadOfState": "Frederick Chiluba", "Capital": 3162, "Code2": "ZM"}, {"Code": "ZWE", "Name": "Zimbabwe", "Continent": "Africa", "Region": "Eastern Africa", "SurfaceArea": 390757.0, "IndepYear": 1980, "Population": 11669000, "LifeExpectancy": 37.8, "GNP": 5951.0, "GNPOld": 8670.0, "LocalName": "Zimbabwe", "GovernmentForm": "Republic", "HeadOfState": "Robert G. Mugabe", "Capital": 4068, "Code2": "ZW"}]}	0.013286113739013672	2021-11-03 13:35:24.072923+00
\.



--
-- Data for Name: query_snippets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.query_snippets (updated_at, created_at, id, org_id, trigger, description, user_id, snippet) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (updated_at, created_at, id, org_id, name, email, profile_image_url, password_hash, groups, api_key, disabled_at, details) FROM stdin;
2021-11-03 13:13:24.1194+00	2021-11-03 13:11:48.611098+00	1	1	admin	admin@localhost.localdomain	\N	$6$rounds=656000$R58taetdw3XoAQ9r$/a.aS33hGD4GIGWAemm/y43tK.W3GDFtscthhXfjpoOLOG25Em4dL5PlY3el3DYXwGfsQlGtmckG71k4WvLin1	{1,2}	XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	\N	{"active_at": "2021-11-03T13:12:42Z"}
\.


--
-- Data for Name: visualizations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.visualizations (updated_at, created_at, id, type, query_id, name, description, options) FROM stdin;
\.


--
-- Data for Name: widgets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.widgets (updated_at, created_at, id, visualization_id, text, width, options, dashboard_id) FROM stdin;
\.


--
-- Name: access_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.access_permissions_id_seq', 1, false);


--
-- Name: alert_subscriptions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.alert_subscriptions_id_seq', 1, false);


--
-- Name: alerts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.alerts_id_seq', 1, false);


--
-- Name: api_keys_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.api_keys_id_seq', 1, false);


--
-- Name: changes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.changes_id_seq', 1, false);


--
-- Name: dashboards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dashboards_id_seq', 1, false);


--
-- Name: data_source_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.data_source_groups_id_seq', 2, true);


--
-- Name: data_sources_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.data_sources_id_seq', 2, true);


--
-- Name: events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.events_id_seq', 18, true);


--
-- Name: favorites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.favorites_id_seq', 1, false);


--
-- Name: groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.groups_id_seq', 2, true);


--
-- Name: notification_destinations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notification_destinations_id_seq', 1, false);


--
-- Name: organizations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.organizations_id_seq', 1, true);


--
-- Name: queries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.queries_id_seq', 1, false);


--
-- Name: query_results_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.query_results_id_seq', 1, false);


--
-- Name: query_snippets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.query_snippets_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- Name: visualizations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.visualizations_id_seq', 1, false);


--
-- Name: widgets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.widgets_id_seq', 1, false);


--
-- Name: access_permissions access_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.access_permissions
    ADD CONSTRAINT access_permissions_pkey PRIMARY KEY (id);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: alert_subscriptions alert_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alert_subscriptions
    ADD CONSTRAINT alert_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: alerts alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT alerts_pkey PRIMARY KEY (id);


--
-- Name: api_keys api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_pkey PRIMARY KEY (id);


--
-- Name: changes changes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.changes
    ADD CONSTRAINT changes_pkey PRIMARY KEY (id);


--
-- Name: dashboards dashboards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboards
    ADD CONSTRAINT dashboards_pkey PRIMARY KEY (id);


--
-- Name: data_source_groups data_source_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_source_groups
    ADD CONSTRAINT data_source_groups_pkey PRIMARY KEY (id);


--
-- Name: data_sources data_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_sources
    ADD CONSTRAINT data_sources_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: favorites favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_pkey PRIMARY KEY (id);


--
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: notification_destinations notification_destinations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_destinations
    ADD CONSTRAINT notification_destinations_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_slug_key UNIQUE (slug);


--
-- Name: queries queries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.queries
    ADD CONSTRAINT queries_pkey PRIMARY KEY (id);


--
-- Name: query_results query_results_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.query_results
    ADD CONSTRAINT query_results_pkey PRIMARY KEY (id);


--
-- Name: query_snippets query_snippets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.query_snippets
    ADD CONSTRAINT query_snippets_pkey PRIMARY KEY (id);


--
-- Name: query_snippets query_snippets_trigger_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.query_snippets
    ADD CONSTRAINT query_snippets_trigger_key UNIQUE (trigger);


--
-- Name: favorites unique_favorite; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT unique_favorite UNIQUE (object_type, object_id, user_id);


--
-- Name: users users_api_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_api_key_key UNIQUE (api_key);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: visualizations visualizations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visualizations
    ADD CONSTRAINT visualizations_pkey PRIMARY KEY (id);


--
-- Name: widgets widgets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.widgets
    ADD CONSTRAINT widgets_pkey PRIMARY KEY (id);


--
-- Name: alert_subscriptions_destination_id_alert_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX alert_subscriptions_destination_id_alert_id ON public.alert_subscriptions USING btree (destination_id, alert_id);


--
-- Name: api_keys_object_type_object_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX api_keys_object_type_object_id ON public.api_keys USING btree (object_type, object_id);


--
-- Name: data_sources_org_id_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX data_sources_org_id_name ON public.data_sources USING btree (org_id, name);


--
-- Name: ix_api_keys_api_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_api_keys_api_key ON public.api_keys USING btree (api_key);


--
-- Name: ix_dashboards_is_archived; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_dashboards_is_archived ON public.dashboards USING btree (is_archived);


--
-- Name: ix_dashboards_is_draft; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_dashboards_is_draft ON public.dashboards USING btree (is_draft);


--
-- Name: ix_dashboards_slug; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_dashboards_slug ON public.dashboards USING btree (slug);


--
-- Name: ix_queries_is_archived; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_queries_is_archived ON public.queries USING btree (is_archived);


--
-- Name: ix_queries_is_draft; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_queries_is_draft ON public.queries USING btree (is_draft);


--
-- Name: ix_queries_search_vector; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_queries_search_vector ON public.queries USING gin (search_vector);


--
-- Name: ix_query_results_query_hash; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_query_results_query_hash ON public.query_results USING btree (query_hash);


--
-- Name: ix_widgets_dashboard_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_widgets_dashboard_id ON public.widgets USING btree (dashboard_id);


--
-- Name: notification_destinations_org_id_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX notification_destinations_org_id_name ON public.notification_destinations USING btree (org_id, name);


--
-- Name: users_org_id_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_org_id_email ON public.users USING btree (org_id, email);


--
-- Name: queries queries_search_vector_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER queries_search_vector_trigger BEFORE INSERT OR UPDATE ON public.queries FOR EACH ROW EXECUTE FUNCTION public.queries_search_vector_update();


--
-- Name: access_permissions access_permissions_grantee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.access_permissions
    ADD CONSTRAINT access_permissions_grantee_id_fkey FOREIGN KEY (grantee_id) REFERENCES public.users(id);


--
-- Name: access_permissions access_permissions_grantor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.access_permissions
    ADD CONSTRAINT access_permissions_grantor_id_fkey FOREIGN KEY (grantor_id) REFERENCES public.users(id);


--
-- Name: alert_subscriptions alert_subscriptions_alert_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alert_subscriptions
    ADD CONSTRAINT alert_subscriptions_alert_id_fkey FOREIGN KEY (alert_id) REFERENCES public.alerts(id);


--
-- Name: alert_subscriptions alert_subscriptions_destination_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alert_subscriptions
    ADD CONSTRAINT alert_subscriptions_destination_id_fkey FOREIGN KEY (destination_id) REFERENCES public.notification_destinations(id);


--
-- Name: alert_subscriptions alert_subscriptions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alert_subscriptions
    ADD CONSTRAINT alert_subscriptions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: alerts alerts_query_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT alerts_query_id_fkey FOREIGN KEY (query_id) REFERENCES public.queries(id);


--
-- Name: alerts alerts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT alerts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: api_keys api_keys_created_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_created_by_id_fkey FOREIGN KEY (created_by_id) REFERENCES public.users(id);


--
-- Name: api_keys api_keys_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id);


--
-- Name: changes changes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.changes
    ADD CONSTRAINT changes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: dashboards dashboards_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboards
    ADD CONSTRAINT dashboards_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id);


--
-- Name: dashboards dashboards_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboards
    ADD CONSTRAINT dashboards_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: data_source_groups data_source_groups_data_source_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_source_groups
    ADD CONSTRAINT data_source_groups_data_source_id_fkey FOREIGN KEY (data_source_id) REFERENCES public.data_sources(id);


--
-- Name: data_source_groups data_source_groups_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_source_groups
    ADD CONSTRAINT data_source_groups_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id);


--
-- Name: data_sources data_sources_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_sources
    ADD CONSTRAINT data_sources_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id);


--
-- Name: events events_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id);


--
-- Name: events events_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: favorites favorites_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id);


--
-- Name: favorites favorites_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: groups groups_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id);


--
-- Name: notification_destinations notification_destinations_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_destinations
    ADD CONSTRAINT notification_destinations_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id);


--
-- Name: notification_destinations notification_destinations_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_destinations
    ADD CONSTRAINT notification_destinations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: queries queries_data_source_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.queries
    ADD CONSTRAINT queries_data_source_id_fkey FOREIGN KEY (data_source_id) REFERENCES public.data_sources(id);


--
-- Name: queries queries_last_modified_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.queries
    ADD CONSTRAINT queries_last_modified_by_id_fkey FOREIGN KEY (last_modified_by_id) REFERENCES public.users(id);


--
-- Name: queries queries_latest_query_data_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.queries
    ADD CONSTRAINT queries_latest_query_data_id_fkey FOREIGN KEY (latest_query_data_id) REFERENCES public.query_results(id);


--
-- Name: queries queries_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.queries
    ADD CONSTRAINT queries_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id);


--
-- Name: queries queries_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.queries
    ADD CONSTRAINT queries_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: query_results query_results_data_source_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.query_results
    ADD CONSTRAINT query_results_data_source_id_fkey FOREIGN KEY (data_source_id) REFERENCES public.data_sources(id);


--
-- Name: query_results query_results_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.query_results
    ADD CONSTRAINT query_results_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id);


--
-- Name: query_snippets query_snippets_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.query_snippets
    ADD CONSTRAINT query_snippets_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id);


--
-- Name: query_snippets query_snippets_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.query_snippets
    ADD CONSTRAINT query_snippets_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: users users_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id);


--
-- Name: visualizations visualizations_query_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visualizations
    ADD CONSTRAINT visualizations_query_id_fkey FOREIGN KEY (query_id) REFERENCES public.queries(id);


--
-- Name: widgets widgets_dashboard_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.widgets
    ADD CONSTRAINT widgets_dashboard_id_fkey FOREIGN KEY (dashboard_id) REFERENCES public.dashboards(id);


--
-- Name: widgets widgets_visualization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.widgets
    ADD CONSTRAINT widgets_visualization_id_fkey FOREIGN KEY (visualization_id) REFERENCES public.visualizations(id);


--
-- PostgreSQL database dump complete
--

