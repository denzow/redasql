--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.25
-- Dumped by pg_dump version 12.2

SET statement_timeout = 0;
SET lock_timeout = 0;
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
    object_id integer NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    id integer NOT NULL,
    org_id integer NOT NULL,
    api_key character varying(255) NOT NULL,
    active boolean NOT NULL,
    created_by_id integer
);


ALTER TABLE public.api_keys OWNER TO postgres;

--
-- Name: api_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.api_keys_id_seq
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
    object_id integer NOT NULL,
    id integer NOT NULL,
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
    tags character varying[]
);


ALTER TABLE public.dashboards OWNER TO postgres;

--
-- Name: dashboards_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dashboards_id_seq
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
    options text NOT NULL,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.notification_destinations OWNER TO postgres;

--
-- Name: notification_destinations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notification_destinations_id_seq
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
e5c7a4e2df4d
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

COPY public.api_keys (object_type, object_id, updated_at, created_at, id, org_id, api_key, active, created_by_id) FROM stdin;
\.


--
-- Data for Name: changes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.changes (object_type, object_id, id, object_version, user_id, change, created_at) FROM stdin;
queries	1	1	1	1	{"last_modified_by_id": {"current": 1, "previous": null}, "user_id": {"current": 1, "previous": null}, "description": {"current": null, "previous": null}, "schedule": {"current": null, "previous": null}, "search_vector": {"current": null, "previous": null}, "is_archived": {"current": false, "previous": null}, "tags": {"current": null, "previous": null}, "org_id": {"current": 1, "previous": 1}, "schedule_failures": {"current": 0, "previous": 0}, "name": {"current": "New Query", "previous": "New Query"}, "query_hash": {"current": "c1e0aa8bdb753c367f93a00cc48f25ed", "previous": "c1e0aa8bdb753c367f93a00cc48f25ed"}, "query": {"current": "select * from country;", "previous": "select * from country;"}, "api_key": {"current": "31YSxDSDxZUQd5modIcpvx17hoqiQcplsJdJCUio", "previous": null}, "is_draft": {"current": true, "previous": true}, "options": {"current": {"parameters": []}, "previous": {"parameters": []}}, "data_source_id": {"current": 1, "previous": null}, "latest_query_data_id": {"current": 1, "previous": 1}}	2021-11-03 08:26:05.665869+00
\.


--
-- Data for Name: dashboards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dashboards (updated_at, created_at, id, version, org_id, slug, name, user_id, layout, dashboard_filters_enabled, is_archived, is_draft, tags) FROM stdin;
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
1	1	MySQL	mysql	\\x6741414141414268676b5a574a764349594e46307366396d47445750657a31366a334b542d506d486266374e466538674f79434643336e664245596556445830496a7742454c78323834474b476851523366707132463534394b4c63356a737974426d4a47623652376e4963337362443750536c4c686d5969466c3749514e386933475147353349424a704f79474455737a6e3251545f65595230673970536734773d3d	queries	scheduled_queries	2021-11-03 08:20:38.933786+00
2	1	metadata	pg	\\x6741414141414268676b5a38576f4b3454447a6b396b3279686631573232486f66354e5248684d416256616a4f4832787665665f6a30544345394d422d3569354433335759545730726d4e6c455962523352564e635137517063484a6562645558355131375264335353643772546e6d526233396b2d6472667a67386868785736775673635359357738735a5345774f33457a5277717a573639776473476d7556532d6d616d76544247624c6a43456e776e47754a653072556f7962476e6d3072684b78695f78787749696e35484c42526e4b484c716c41564c5a794e75737050673d3d	queries	scheduled_queries	2021-11-03 08:21:13.15171+00
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events (id, org_id, user_id, action, object_type, object_id, additional_properties, created_at) FROM stdin;
1	1	1	login	redash	\N	{"ip": "172.30.0.1", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"}	2021-11-03 08:05:43+00
2	1	1	load_favorites	query	\N	{"ip": "172.30.0.1", "params": {"q": null, "page": 1, "tags": []}, "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36", "user_name": "admin"}	2021-11-03 08:05:44+00
3	1	1	load_favorites	dashboard	\N	{"ip": "172.30.0.1", "params": {"q": null, "page": 1, "tags": []}, "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36", "user_name": "admin"}	2021-11-03 08:05:44+00
4	1	1	load_favorites	dashboard	\N	{"ip": "172.30.0.1", "params": {"q": null, "page": 1, "tags": []}, "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36", "user_name": "admin"}	2021-11-03 08:05:44+00
5	1	1	load_favorites	query	\N	{"ip": "172.30.0.1", "params": {"q": null, "page": 1, "tags": []}, "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36", "user_name": "admin"}	2021-11-03 08:05:44+00
6	1	1	view	page	personal_homepage	{"screen_resolution": "1920x1080", "ip": "172.30.0.1", "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"}	2021-11-03 08:05:44.413+00
7	1	1	load_favorites	dashboard	\N	{"ip": "192.168.16.1", "params": {"q": null, "page": 1, "tags": []}, "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36", "user_name": "admin"}	2021-11-03 08:19:33+00
8	1	1	load_favorites	query	\N	{"ip": "192.168.16.1", "params": {"q": null, "page": 1, "tags": []}, "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36", "user_name": "admin"}	2021-11-03 08:19:33+00
9	1	1	load_favorites	dashboard	\N	{"ip": "192.168.16.1", "params": {"q": null, "page": 1, "tags": []}, "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36", "user_name": "admin"}	2021-11-03 08:19:33+00
10	1	1	load_favorites	query	\N	{"ip": "192.168.16.1", "params": {"q": null, "page": 1, "tags": []}, "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36", "user_name": "admin"}	2021-11-03 08:19:33+00
11	1	1	view	page	personal_homepage	{"screen_resolution": "1920x1080", "ip": "192.168.16.1", "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"}	2021-11-03 08:19:33.087+00
12	1	1	view	user	1	{"ip": "192.168.16.1", "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"}	2021-11-03 08:19:36+00
13	1	1	list	group	groups	{"ip": "192.168.16.1", "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"}	2021-11-03 08:19:36+00
14	1	1	list	datasource	admin/data_sources	{"ip": "192.168.16.1", "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"}	2021-11-03 08:19:38+00
15	1	1	view	page	data_sources/new	{"screen_resolution": "1920x1080", "ip": "192.168.16.1", "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"}	2021-11-03 08:19:39.699+00
16	1	1	create	datasource	1	{"ip": "192.168.16.1", "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"}	2021-11-03 08:20:38+00
17	1	1	list	datasource	admin/data_sources	{"ip": "192.168.16.1", "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"}	2021-11-03 08:20:39+00
18	1	1	view	datasource	1	{"ip": "192.168.16.1", "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"}	2021-11-03 08:20:39+00
19	1	1	test	datasource	1	{"ip": "192.168.16.1", "user_name": "admin", "result": {"message": "success", "ok": true}, "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"}	2021-11-03 08:20:41+00
20	1	1	list	datasource	admin/data_sources	{"ip": "192.168.16.1", "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"}	2021-11-03 08:20:45+00
21	1	1	view	page	data_sources/new	{"screen_resolution": "1920x1080", "ip": "192.168.16.1", "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"}	2021-11-03 08:20:45.88+00
22	1	1	create	datasource	2	{"ip": "192.168.16.1", "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"}	2021-11-03 08:21:13+00
23	1	1	list	datasource	admin/data_sources	{"ip": "192.168.16.1", "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"}	2021-11-03 08:21:13+00
24	1	1	view	datasource	2	{"ip": "192.168.16.1", "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"}	2021-11-03 08:21:13+00
25	1	1	test	datasource	2	{"ip": "192.168.16.1", "user_name": "admin", "result": {"message": "success", "ok": true}, "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"}	2021-11-03 08:21:14+00
26	1	1	edit	datasource	2	{"ip": "192.168.16.1", "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"}	2021-11-03 08:21:16+00
27	1	1	load_favorites	query	\N	{"ip": "192.168.32.1", "params": {"q": null, "page": 1, "tags": []}, "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36", "user_name": "admin"}	2021-11-03 08:25:40+00
28	1	1	load_favorites	dashboard	\N	{"ip": "192.168.32.1", "params": {"q": null, "page": 1, "tags": []}, "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36", "user_name": "admin"}	2021-11-03 08:25:40+00
29	1	1	load_favorites	query	\N	{"ip": "192.168.32.1", "params": {"q": null, "page": 1, "tags": []}, "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36", "user_name": "admin"}	2021-11-03 08:25:40+00
30	1	1	load_favorites	dashboard	\N	{"ip": "192.168.32.1", "params": {"q": null, "page": 1, "tags": []}, "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36", "user_name": "admin"}	2021-11-03 08:25:40+00
31	1	1	view	page	personal_homepage	{"screen_resolution": "1920x1080", "ip": "192.168.32.1", "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"}	2021-11-03 08:25:40.007+00
32	1	1	list	datasource	admin/data_sources	{"ip": "192.168.32.1", "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"}	2021-11-03 08:25:42+00
33	1	1	list	datasource	admin/data_sources	{"ip": "192.168.32.1", "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"}	2021-11-03 08:25:47+00
34	1	1	list	query_snippet	\N	{"ip": "192.168.32.1", "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"}	2021-11-03 08:25:47+00
35	1	1	view_source	query	\N	{"screen_resolution": "1920x1080", "ip": "192.168.32.1", "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"}	2021-11-03 08:25:47.152+00
36	1	1	execute_query	data_source	1	{"query_id": "adhoc", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36", "parameters": {}, "query": "select * from ", "ip": "192.168.32.1", "cache": "miss", "user_name": "admin"}	2021-11-03 08:25:58+00
38	1	1	update_data_source	query	\N	{"screen_resolution": "1920x1080", "ip": "192.168.32.1", "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"}	2021-11-03 08:25:58.187+00
37	1	1	execute	query	\N	{"screen_resolution": "1920x1080", "ip": "192.168.32.1", "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"}	2021-11-03 08:25:58.19+00
39	1	1	execute_query	data_source	1	{"query_id": "adhoc", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36", "parameters": {}, "query": "select * from country;", "ip": "192.168.32.1", "cache": "miss", "user_name": "admin"}	2021-11-03 08:26:04+00
40	1	1	execute	query	\N	{"screen_resolution": "1920x1080", "ip": "192.168.32.1", "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"}	2021-11-03 08:26:03.997+00
41	1	1	create	query	1	{"ip": "192.168.32.1", "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"}	2021-11-03 08:26:05+00
42	1	1	view	query	1	{"ip": "192.168.32.1", "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"}	2021-11-03 08:26:05+00
43	1	1	list	datasource	admin/data_sources	{"ip": "192.168.32.1", "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"}	2021-11-03 08:26:05+00
44	1	1	list	query_snippet	\N	{"ip": "192.168.32.1", "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"}	2021-11-03 08:26:06+00
45	1	1	view_source	query	1	{"screen_resolution": "1920x1080", "ip": "192.168.32.1", "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"}	2021-11-03 08:26:05.902+00
46	1	1	execute_query	data_source	1	{"query_id": "1", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36", "parameters": {}, "query": "select * from country order by 1;", "ip": "192.168.32.1", "cache": "miss", "user_name": "admin"}	2021-11-03 08:26:13+00
47	1	1	execute	query	1	{"screen_resolution": "1920x1080", "ip": "192.168.32.1", "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"}	2021-11-03 08:26:13.124+00
48	1	1	edit_name	query	1	{"screen_resolution": "1920x1080", "ip": "192.168.32.1", "user_name": "admin", "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"}	2021-11-03 08:26:18.55+00
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
1	1	builtin	admin	{admin,super_admin}	2021-11-03 08:05:43.258189+00
2	1	builtin	default	{create_dashboard,create_query,edit_dashboard,edit_query,view_query,view_source,execute_query,list_users,schedule_query,list_dashboards,list_alerts,list_data_sources}	2021-11-03 08:05:43.258189+00
\.


--
-- Data for Name: notification_destinations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification_destinations (id, org_id, user_id, name, type, options, created_at) FROM stdin;
\.


--
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organizations (updated_at, created_at, id, name, slug, settings) FROM stdin;
2021-11-03 08:26:05.665869+00	2021-11-03 08:05:43.258189+00	1	redasql	default	{}
\.


--
-- Data for Name: queries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.queries (updated_at, created_at, id, version, org_id, data_source_id, latest_query_data_id, name, description, query, query_hash, api_key, user_id, last_modified_by_id, is_archived, is_draft, schedule, schedule_failures, options, search_vector, tags) FROM stdin;
2021-11-03 08:26:20.930798+00	2021-11-03 08:26:05.665869+00	1	1	1	1	2	country list	\N	select * from country order by 1;	5de66f59170c0b2f3b0ef74db5850627	31YSxDSDxZUQd5modIcpvx17hoqiQcplsJdJCUio	1	1	f	f	\N	0	{"parameters": []}	'1':1B,9 'by':8 'country':2A,6 'from':5 'list':3A 'order':7 'select':4	\N
\.


--
-- Data for Name: query_results; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.query_results (id, org_id, data_source_id, query_hash, query, data, runtime, retrieved_at) FROM stdin;
1	1	1	c1e0aa8bdb753c367f93a00cc48f25ed	select * from country;	{"rows": [{"GovernmentForm": "Nonmetropolitan Territory of The Netherlands", "GNP": 828.0, "Code": "ABW", "Name": "Aruba", "HeadOfState": "Beatrix", "Region": "Caribbean", "Capital": 129, "Code2": "AW", "LifeExpectancy": 78.4, "LocalName": "Aruba", "SurfaceArea": 193.0, "GNPOld": 793.0, "Continent": "North America", "IndepYear": null, "Population": 103000}, {"GovernmentForm": "Islamic Emirate", "GNP": 5976.0, "Code": "AFG", "Name": "Afghanistan", "HeadOfState": "Mohammad Omar", "Region": "Southern and Central Asia", "Capital": 1, "Code2": "AF", "LifeExpectancy": 45.9, "LocalName": "Afganistan/Afqanestan", "SurfaceArea": 652090.0, "GNPOld": null, "Continent": "Asia", "IndepYear": 1919, "Population": 22720000}, {"GovernmentForm": "Republic", "GNP": 6648.0, "Code": "AGO", "Name": "Angola", "HeadOfState": "Jos\\u00e9 Eduardo dos Santos", "Region": "Central Africa", "Capital": 56, "Code2": "AO", "LifeExpectancy": 38.3, "LocalName": "Angola", "SurfaceArea": 1246700.0, "GNPOld": 7984.0, "Continent": "Africa", "IndepYear": 1975, "Population": 12878000}, {"GovernmentForm": "Dependent Territory of the UK", "GNP": 63.2, "Code": "AIA", "Name": "Anguilla", "HeadOfState": "Elisabeth II", "Region": "Caribbean", "Capital": 62, "Code2": "AI", "LifeExpectancy": 76.1, "LocalName": "Anguilla", "SurfaceArea": 96.0, "GNPOld": null, "Continent": "North America", "IndepYear": null, "Population": 8000}, {"GovernmentForm": "Republic", "GNP": 3205.0, "Code": "ALB", "Name": "Albania", "HeadOfState": "Rexhep Mejdani", "Region": "Southern Europe", "Capital": 34, "Code2": "AL", "LifeExpectancy": 71.6, "LocalName": "Shqip\\u00ebria", "SurfaceArea": 28748.0, "GNPOld": 2500.0, "Continent": "Europe", "IndepYear": 1912, "Population": 3401200}, {"GovernmentForm": "Parliamentary Coprincipality", "GNP": 1630.0, "Code": "AND", "Name": "Andorra", "HeadOfState": "", "Region": "Southern Europe", "Capital": 55, "Code2": "AD", "LifeExpectancy": 83.5, "LocalName": "Andorra", "SurfaceArea": 468.0, "GNPOld": null, "Continent": "Europe", "IndepYear": 1278, "Population": 78000}, {"GovernmentForm": "Nonmetropolitan Territory of The Netherlands", "GNP": 1941.0, "Code": "ANT", "Name": "Netherlands Antilles", "HeadOfState": "Beatrix", "Region": "Caribbean", "Capital": 33, "Code2": "AN", "LifeExpectancy": 74.7, "LocalName": "Nederlandse Antillen", "SurfaceArea": 800.0, "GNPOld": null, "Continent": "North America", "IndepYear": null, "Population": 217000}, {"GovernmentForm": "Emirate Federation", "GNP": 37966.0, "Code": "ARE", "Name": "United Arab Emirates", "HeadOfState": "Zayid bin Sultan al-Nahayan", "Region": "Middle East", "Capital": 65, "Code2": "AE", "LifeExpectancy": 74.1, "LocalName": "Al-Imarat al-\\u00b4Arabiya al-Muttahida", "SurfaceArea": 83600.0, "GNPOld": 36846.0, "Continent": "Asia", "IndepYear": 1971, "Population": 2441000}, {"GovernmentForm": "Federal Republic", "GNP": 340238.0, "Code": "ARG", "Name": "Argentina", "HeadOfState": "Fernando de la R\\u00faa", "Region": "South America", "Capital": 69, "Code2": "AR", "LifeExpectancy": 75.1, "LocalName": "Argentina", "SurfaceArea": 2780400.0, "GNPOld": 323310.0, "Continent": "South America", "IndepYear": 1816, "Population": 37032000}, {"GovernmentForm": "Republic", "GNP": 1813.0, "Code": "ARM", "Name": "Armenia", "HeadOfState": "Robert Kot\\u0161arjan", "Region": "Middle East", "Capital": 126, "Code2": "AM", "LifeExpectancy": 66.4, "LocalName": "Hajastan", "SurfaceArea": 29800.0, "GNPOld": 1627.0, "Continent": "Asia", "IndepYear": 1991, "Population": 3520000}, {"GovernmentForm": "US Territory", "GNP": 334.0, "Code": "ASM", "Name": "American Samoa", "HeadOfState": "George W. Bush", "Region": "Polynesia", "Capital": 54, "Code2": "AS", "LifeExpectancy": 75.1, "LocalName": "Amerika Samoa", "SurfaceArea": 199.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": null, "Population": 68000}, {"GovernmentForm": "Co-administrated", "GNP": 0.0, "Code": "ATA", "Name": "Antarctica", "HeadOfState": "", "Region": "Antarctica", "Capital": null, "Code2": "AQ", "LifeExpectancy": null, "LocalName": "\\u2013", "SurfaceArea": 13120000.0, "GNPOld": null, "Continent": "Antarctica", "IndepYear": null, "Population": 0}, {"GovernmentForm": "Nonmetropolitan Territory of France", "GNP": 0.0, "Code": "ATF", "Name": "French Southern territories", "HeadOfState": "Jacques Chirac", "Region": "Antarctica", "Capital": null, "Code2": "TF", "LifeExpectancy": null, "LocalName": "Terres australes fran\\u00e7aises", "SurfaceArea": 7780.0, "GNPOld": null, "Continent": "Antarctica", "IndepYear": null, "Population": 0}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 612.0, "Code": "ATG", "Name": "Antigua and Barbuda", "HeadOfState": "Elisabeth II", "Region": "Caribbean", "Capital": 63, "Code2": "AG", "LifeExpectancy": 70.5, "LocalName": "Antigua and Barbuda", "SurfaceArea": 442.0, "GNPOld": 584.0, "Continent": "North America", "IndepYear": 1981, "Population": 68000}, {"GovernmentForm": "Constitutional Monarchy, Federation", "GNP": 351182.0, "Code": "AUS", "Name": "Australia", "HeadOfState": "Elisabeth II", "Region": "Australia and New Zealand", "Capital": 135, "Code2": "AU", "LifeExpectancy": 79.8, "LocalName": "Australia", "SurfaceArea": 7741220.0, "GNPOld": 392911.0, "Continent": "Oceania", "IndepYear": 1901, "Population": 18886000}, {"GovernmentForm": "Federal Republic", "GNP": 211860.0, "Code": "AUT", "Name": "Austria", "HeadOfState": "Thomas Klestil", "Region": "Western Europe", "Capital": 1523, "Code2": "AT", "LifeExpectancy": 77.7, "LocalName": "\\u00d6sterreich", "SurfaceArea": 83859.0, "GNPOld": 206025.0, "Continent": "Europe", "IndepYear": 1918, "Population": 8091800}, {"GovernmentForm": "Federal Republic", "GNP": 4127.0, "Code": "AZE", "Name": "Azerbaijan", "HeadOfState": "Heyd\\u00e4r \\u00c4liyev", "Region": "Middle East", "Capital": 144, "Code2": "AZ", "LifeExpectancy": 62.9, "LocalName": "Az\\u00e4rbaycan", "SurfaceArea": 86600.0, "GNPOld": 4100.0, "Continent": "Asia", "IndepYear": 1991, "Population": 7734000}, {"GovernmentForm": "Republic", "GNP": 903.0, "Code": "BDI", "Name": "Burundi", "HeadOfState": "Pierre Buyoya", "Region": "Eastern Africa", "Capital": 552, "Code2": "BI", "LifeExpectancy": 46.2, "LocalName": "Burundi/Uburundi", "SurfaceArea": 27834.0, "GNPOld": 982.0, "Continent": "Africa", "IndepYear": 1962, "Population": 6695000}, {"GovernmentForm": "Constitutional Monarchy, Federation", "GNP": 249704.0, "Code": "BEL", "Name": "Belgium", "HeadOfState": "Albert II", "Region": "Western Europe", "Capital": 179, "Code2": "BE", "LifeExpectancy": 77.8, "LocalName": "Belgi\\u00eb/Belgique", "SurfaceArea": 30518.0, "GNPOld": 243948.0, "Continent": "Europe", "IndepYear": 1830, "Population": 10239000}, {"GovernmentForm": "Republic", "GNP": 2357.0, "Code": "BEN", "Name": "Benin", "HeadOfState": "Mathieu K\\u00e9r\\u00e9kou", "Region": "Western Africa", "Capital": 187, "Code2": "BJ", "LifeExpectancy": 50.2, "LocalName": "B\\u00e9nin", "SurfaceArea": 112622.0, "GNPOld": 2141.0, "Continent": "Africa", "IndepYear": 1960, "Population": 6097000}, {"GovernmentForm": "Republic", "GNP": 2425.0, "Code": "BFA", "Name": "Burkina Faso", "HeadOfState": "Blaise Compaor\\u00e9", "Region": "Western Africa", "Capital": 549, "Code2": "BF", "LifeExpectancy": 46.7, "LocalName": "Burkina Faso", "SurfaceArea": 274000.0, "GNPOld": 2201.0, "Continent": "Africa", "IndepYear": 1960, "Population": 11937000}, {"GovernmentForm": "Republic", "GNP": 32852.0, "Code": "BGD", "Name": "Bangladesh", "HeadOfState": "Shahabuddin Ahmad", "Region": "Southern and Central Asia", "Capital": 150, "Code2": "BD", "LifeExpectancy": 60.2, "LocalName": "Bangladesh", "SurfaceArea": 143998.0, "GNPOld": 31966.0, "Continent": "Asia", "IndepYear": 1971, "Population": 129155000}, {"GovernmentForm": "Republic", "GNP": 12178.0, "Code": "BGR", "Name": "Bulgaria", "HeadOfState": "Petar Stojanov", "Region": "Eastern Europe", "Capital": 539, "Code2": "BG", "LifeExpectancy": 70.9, "LocalName": "Balgarija", "SurfaceArea": 110994.0, "GNPOld": 10169.0, "Continent": "Europe", "IndepYear": 1908, "Population": 8190900}, {"GovernmentForm": "Monarchy (Emirate)", "GNP": 6366.0, "Code": "BHR", "Name": "Bahrain", "HeadOfState": "Hamad ibn Isa al-Khalifa", "Region": "Middle East", "Capital": 149, "Code2": "BH", "LifeExpectancy": 73.0, "LocalName": "Al-Bahrayn", "SurfaceArea": 694.0, "GNPOld": 6097.0, "Continent": "Asia", "IndepYear": 1971, "Population": 617000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 3527.0, "Code": "BHS", "Name": "Bahamas", "HeadOfState": "Elisabeth II", "Region": "Caribbean", "Capital": 148, "Code2": "BS", "LifeExpectancy": 71.1, "LocalName": "The Bahamas", "SurfaceArea": 13878.0, "GNPOld": 3347.0, "Continent": "North America", "IndepYear": 1973, "Population": 307000}, {"GovernmentForm": "Federal Republic", "GNP": 2841.0, "Code": "BIH", "Name": "Bosnia and Herzegovina", "HeadOfState": "Ante Jelavic", "Region": "Southern Europe", "Capital": 201, "Code2": "BA", "LifeExpectancy": 71.5, "LocalName": "Bosna i Hercegovina", "SurfaceArea": 51197.0, "GNPOld": null, "Continent": "Europe", "IndepYear": 1992, "Population": 3972000}, {"GovernmentForm": "Republic", "GNP": 13714.0, "Code": "BLR", "Name": "Belarus", "HeadOfState": "Aljaksandr Luka\\u0161enka", "Region": "Eastern Europe", "Capital": 3520, "Code2": "BY", "LifeExpectancy": 68.0, "LocalName": "Belarus", "SurfaceArea": 207600.0, "GNPOld": null, "Continent": "Europe", "IndepYear": 1991, "Population": 10236000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 630.0, "Code": "BLZ", "Name": "Belize", "HeadOfState": "Elisabeth II", "Region": "Central America", "Capital": 185, "Code2": "BZ", "LifeExpectancy": 70.9, "LocalName": "Belize", "SurfaceArea": 22696.0, "GNPOld": 616.0, "Continent": "North America", "IndepYear": 1981, "Population": 241000}, {"GovernmentForm": "Dependent Territory of the UK", "GNP": 2328.0, "Code": "BMU", "Name": "Bermuda", "HeadOfState": "Elisabeth II", "Region": "North America", "Capital": 191, "Code2": "BM", "LifeExpectancy": 76.9, "LocalName": "Bermuda", "SurfaceArea": 53.0, "GNPOld": 2190.0, "Continent": "North America", "IndepYear": null, "Population": 65000}, {"GovernmentForm": "Republic", "GNP": 8571.0, "Code": "BOL", "Name": "Bolivia", "HeadOfState": "Hugo B\\u00e1nzer Su\\u00e1rez", "Region": "South America", "Capital": 194, "Code2": "BO", "LifeExpectancy": 63.7, "LocalName": "Bolivia", "SurfaceArea": 1098581.0, "GNPOld": 7967.0, "Continent": "South America", "IndepYear": 1825, "Population": 8329000}, {"GovernmentForm": "Federal Republic", "GNP": 776739.0, "Code": "BRA", "Name": "Brazil", "HeadOfState": "Fernando Henrique Cardoso", "Region": "South America", "Capital": 211, "Code2": "BR", "LifeExpectancy": 62.9, "LocalName": "Brasil", "SurfaceArea": 8547403.0, "GNPOld": 804108.0, "Continent": "South America", "IndepYear": 1822, "Population": 170115000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 2223.0, "Code": "BRB", "Name": "Barbados", "HeadOfState": "Elisabeth II", "Region": "Caribbean", "Capital": 174, "Code2": "BB", "LifeExpectancy": 73.0, "LocalName": "Barbados", "SurfaceArea": 430.0, "GNPOld": 2186.0, "Continent": "North America", "IndepYear": 1966, "Population": 270000}, {"GovernmentForm": "Monarchy (Sultanate)", "GNP": 11705.0, "Code": "BRN", "Name": "Brunei", "HeadOfState": "Haji Hassan al-Bolkiah", "Region": "Southeast Asia", "Capital": 538, "Code2": "BN", "LifeExpectancy": 73.6, "LocalName": "Brunei Darussalam", "SurfaceArea": 5765.0, "GNPOld": 12460.0, "Continent": "Asia", "IndepYear": 1984, "Population": 328000}, {"GovernmentForm": "Monarchy", "GNP": 372.0, "Code": "BTN", "Name": "Bhutan", "HeadOfState": "Jigme Singye Wangchuk", "Region": "Southern and Central Asia", "Capital": 192, "Code2": "BT", "LifeExpectancy": 52.4, "LocalName": "Druk-Yul", "SurfaceArea": 47000.0, "GNPOld": 383.0, "Continent": "Asia", "IndepYear": 1910, "Population": 2124000}, {"GovernmentForm": "Dependent Territory of Norway", "GNP": 0.0, "Code": "BVT", "Name": "Bouvet Island", "HeadOfState": "Harald V", "Region": "Antarctica", "Capital": null, "Code2": "BV", "LifeExpectancy": null, "LocalName": "Bouvet\\u00f8ya", "SurfaceArea": 59.0, "GNPOld": null, "Continent": "Antarctica", "IndepYear": null, "Population": 0}, {"GovernmentForm": "Republic", "GNP": 4834.0, "Code": "BWA", "Name": "Botswana", "HeadOfState": "Festus G. Mogae", "Region": "Southern Africa", "Capital": 204, "Code2": "BW", "LifeExpectancy": 39.3, "LocalName": "Botswana", "SurfaceArea": 581730.0, "GNPOld": 4935.0, "Continent": "Africa", "IndepYear": 1966, "Population": 1622000}, {"GovernmentForm": "Republic", "GNP": 1054.0, "Code": "CAF", "Name": "Central African Republic", "HeadOfState": "Ange-F\\u00e9lix Patass\\u00e9", "Region": "Central Africa", "Capital": 1889, "Code2": "CF", "LifeExpectancy": 44.0, "LocalName": "Centrafrique/B\\u00ea-Afr\\u00eeka", "SurfaceArea": 622984.0, "GNPOld": 993.0, "Continent": "Africa", "IndepYear": 1960, "Population": 3615000}, {"GovernmentForm": "Constitutional Monarchy, Federation", "GNP": 598862.0, "Code": "CAN", "Name": "Canada", "HeadOfState": "Elisabeth II", "Region": "North America", "Capital": 1822, "Code2": "CA", "LifeExpectancy": 79.4, "LocalName": "Canada", "SurfaceArea": 9970610.0, "GNPOld": 625626.0, "Continent": "North America", "IndepYear": 1867, "Population": 31147000}, {"GovernmentForm": "Territory of Australia", "GNP": 0.0, "Code": "CCK", "Name": "Cocos (Keeling) Islands", "HeadOfState": "Elisabeth II", "Region": "Australia and New Zealand", "Capital": 2317, "Code2": "CC", "LifeExpectancy": null, "LocalName": "Cocos (Keeling) Islands", "SurfaceArea": 14.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": null, "Population": 600}, {"GovernmentForm": "Federation", "GNP": 264478.0, "Code": "CHE", "Name": "Switzerland", "HeadOfState": "Adolf Ogi", "Region": "Western Europe", "Capital": 3248, "Code2": "CH", "LifeExpectancy": 79.6, "LocalName": "Schweiz/Suisse/Svizzera/Svizra", "SurfaceArea": 41284.0, "GNPOld": 256092.0, "Continent": "Europe", "IndepYear": 1499, "Population": 7160400}, {"GovernmentForm": "Republic", "GNP": 72949.0, "Code": "CHL", "Name": "Chile", "HeadOfState": "Ricardo Lagos Escobar", "Region": "South America", "Capital": 554, "Code2": "CL", "LifeExpectancy": 75.7, "LocalName": "Chile", "SurfaceArea": 756626.0, "GNPOld": 75780.0, "Continent": "South America", "IndepYear": 1810, "Population": 15211000}, {"GovernmentForm": "People'sRepublic", "GNP": 982268.0, "Code": "CHN", "Name": "China", "HeadOfState": "Jiang Zemin", "Region": "Eastern Asia", "Capital": 1891, "Code2": "CN", "LifeExpectancy": 71.4, "LocalName": "Zhongquo", "SurfaceArea": 9572900.0, "GNPOld": 917719.0, "Continent": "Asia", "IndepYear": -1523, "Population": 1277558000}, {"GovernmentForm": "Republic", "GNP": 11345.0, "Code": "CIV", "Name": "C\\u00f4te d\\u2019Ivoire", "HeadOfState": "Laurent Gbagbo", "Region": "Western Africa", "Capital": 2814, "Code2": "CI", "LifeExpectancy": 45.2, "LocalName": "C\\u00f4te d\\u2019Ivoire", "SurfaceArea": 322463.0, "GNPOld": 10285.0, "Continent": "Africa", "IndepYear": 1960, "Population": 14786000}, {"GovernmentForm": "Republic", "GNP": 9174.0, "Code": "CMR", "Name": "Cameroon", "HeadOfState": "Paul Biya", "Region": "Central Africa", "Capital": 1804, "Code2": "CM", "LifeExpectancy": 54.8, "LocalName": "Cameroun/Cameroon", "SurfaceArea": 475442.0, "GNPOld": 8596.0, "Continent": "Africa", "IndepYear": 1960, "Population": 15085000}, {"GovernmentForm": "Republic", "GNP": 6964.0, "Code": "COD", "Name": "Congo, The Democratic Republic of the", "HeadOfState": "Joseph Kabila", "Region": "Central Africa", "Capital": 2298, "Code2": "CD", "LifeExpectancy": 48.8, "LocalName": "R\\u00e9publique D\\u00e9mocratique du Congo", "SurfaceArea": 2344858.0, "GNPOld": 2474.0, "Continent": "Africa", "IndepYear": 1960, "Population": 51654000}, {"GovernmentForm": "Republic", "GNP": 2108.0, "Code": "COG", "Name": "Congo", "HeadOfState": "Denis Sassou-Nguesso", "Region": "Central Africa", "Capital": 2296, "Code2": "CG", "LifeExpectancy": 47.4, "LocalName": "Congo", "SurfaceArea": 342000.0, "GNPOld": 2287.0, "Continent": "Africa", "IndepYear": 1960, "Population": 2943000}, {"GovernmentForm": "Nonmetropolitan Territory of New Zealand", "GNP": 100.0, "Code": "COK", "Name": "Cook Islands", "HeadOfState": "Elisabeth II", "Region": "Polynesia", "Capital": 583, "Code2": "CK", "LifeExpectancy": 71.1, "LocalName": "The Cook Islands", "SurfaceArea": 236.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": null, "Population": 20000}, {"GovernmentForm": "Republic", "GNP": 102896.0, "Code": "COL", "Name": "Colombia", "HeadOfState": "Andr\\u00e9s Pastrana Arango", "Region": "South America", "Capital": 2257, "Code2": "CO", "LifeExpectancy": 70.3, "LocalName": "Colombia", "SurfaceArea": 1138914.0, "GNPOld": 105116.0, "Continent": "South America", "IndepYear": 1810, "Population": 42321000}, {"GovernmentForm": "Republic", "GNP": 4401.0, "Code": "COM", "Name": "Comoros", "HeadOfState": "Azali Assoumani", "Region": "Eastern Africa", "Capital": 2295, "Code2": "KM", "LifeExpectancy": 60.0, "LocalName": "Komori/Comores", "SurfaceArea": 1862.0, "GNPOld": 4361.0, "Continent": "Africa", "IndepYear": 1975, "Population": 578000}, {"GovernmentForm": "Republic", "GNP": 435.0, "Code": "CPV", "Name": "Cape Verde", "HeadOfState": "Ant\\u00f3nio Mascarenhas Monteiro", "Region": "Western Africa", "Capital": 1859, "Code2": "CV", "LifeExpectancy": 68.9, "LocalName": "Cabo Verde", "SurfaceArea": 4033.0, "GNPOld": 420.0, "Continent": "Africa", "IndepYear": 1975, "Population": 428000}, {"GovernmentForm": "Republic", "GNP": 10226.0, "Code": "CRI", "Name": "Costa Rica", "HeadOfState": "Miguel \\u00c1ngel Rodr\\u00edguez Echeverr\\u00eda", "Region": "Central America", "Capital": 584, "Code2": "CR", "LifeExpectancy": 75.8, "LocalName": "Costa Rica", "SurfaceArea": 51100.0, "GNPOld": 9757.0, "Continent": "North America", "IndepYear": 1821, "Population": 4023000}, {"GovernmentForm": "Socialistic Republic", "GNP": 17843.0, "Code": "CUB", "Name": "Cuba", "HeadOfState": "Fidel Castro Ruz", "Region": "Caribbean", "Capital": 2413, "Code2": "CU", "LifeExpectancy": 76.2, "LocalName": "Cuba", "SurfaceArea": 110861.0, "GNPOld": 18862.0, "Continent": "North America", "IndepYear": 1902, "Population": 11201000}, {"GovernmentForm": "Territory of Australia", "GNP": 0.0, "Code": "CXR", "Name": "Christmas Island", "HeadOfState": "Elisabeth II", "Region": "Australia and New Zealand", "Capital": 1791, "Code2": "CX", "LifeExpectancy": null, "LocalName": "Christmas Island", "SurfaceArea": 135.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": null, "Population": 2500}, {"GovernmentForm": "Dependent Territory of the UK", "GNP": 1263.0, "Code": "CYM", "Name": "Cayman Islands", "HeadOfState": "Elisabeth II", "Region": "Caribbean", "Capital": 553, "Code2": "KY", "LifeExpectancy": 78.9, "LocalName": "Cayman Islands", "SurfaceArea": 264.0, "GNPOld": 1186.0, "Continent": "North America", "IndepYear": null, "Population": 38000}, {"GovernmentForm": "Republic", "GNP": 9333.0, "Code": "CYP", "Name": "Cyprus", "HeadOfState": "Glafkos Klerides", "Region": "Middle East", "Capital": 2430, "Code2": "CY", "LifeExpectancy": 76.7, "LocalName": "K\\u00fdpros/Kibris", "SurfaceArea": 9251.0, "GNPOld": 8246.0, "Continent": "Asia", "IndepYear": 1960, "Population": 754700}, {"GovernmentForm": "Republic", "GNP": 55017.0, "Code": "CZE", "Name": "Czech Republic", "HeadOfState": "V\\u00e1clav Havel", "Region": "Eastern Europe", "Capital": 3339, "Code2": "CZ", "LifeExpectancy": 74.5, "LocalName": "\\u00b8esko", "SurfaceArea": 78866.0, "GNPOld": 52037.0, "Continent": "Europe", "IndepYear": 1993, "Population": 10278100}, {"GovernmentForm": "Federal Republic", "GNP": 2133367.0, "Code": "DEU", "Name": "Germany", "HeadOfState": "Johannes Rau", "Region": "Western Europe", "Capital": 3068, "Code2": "DE", "LifeExpectancy": 77.4, "LocalName": "Deutschland", "SurfaceArea": 357022.0, "GNPOld": 2102826.0, "Continent": "Europe", "IndepYear": 1955, "Population": 82164700}, {"GovernmentForm": "Republic", "GNP": 382.0, "Code": "DJI", "Name": "Djibouti", "HeadOfState": "Ismail Omar Guelleh", "Region": "Eastern Africa", "Capital": 585, "Code2": "DJ", "LifeExpectancy": 50.8, "LocalName": "Djibouti/Jibuti", "SurfaceArea": 23200.0, "GNPOld": 373.0, "Continent": "Africa", "IndepYear": 1977, "Population": 638000}, {"GovernmentForm": "Republic", "GNP": 256.0, "Code": "DMA", "Name": "Dominica", "HeadOfState": "Vernon Shaw", "Region": "Caribbean", "Capital": 586, "Code2": "DM", "LifeExpectancy": 73.4, "LocalName": "Dominica", "SurfaceArea": 751.0, "GNPOld": 243.0, "Continent": "North America", "IndepYear": 1978, "Population": 71000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 174099.0, "Code": "DNK", "Name": "Denmark", "HeadOfState": "Margrethe II", "Region": "Nordic Countries", "Capital": 3315, "Code2": "DK", "LifeExpectancy": 76.5, "LocalName": "Danmark", "SurfaceArea": 43094.0, "GNPOld": 169264.0, "Continent": "Europe", "IndepYear": 800, "Population": 5330000}, {"GovernmentForm": "Republic", "GNP": 15846.0, "Code": "DOM", "Name": "Dominican Republic", "HeadOfState": "Hip\\u00f3lito Mej\\u00eda Dom\\u00ednguez", "Region": "Caribbean", "Capital": 587, "Code2": "DO", "LifeExpectancy": 73.2, "LocalName": "Rep\\u00fablica Dominicana", "SurfaceArea": 48511.0, "GNPOld": 15076.0, "Continent": "North America", "IndepYear": 1844, "Population": 8495000}, {"GovernmentForm": "Republic", "GNP": 49982.0, "Code": "DZA", "Name": "Algeria", "HeadOfState": "Abdelaziz Bouteflika", "Region": "Northern Africa", "Capital": 35, "Code2": "DZ", "LifeExpectancy": 69.7, "LocalName": "Al-Jaza\\u2019ir/Alg\\u00e9rie", "SurfaceArea": 2381741.0, "GNPOld": 46966.0, "Continent": "Africa", "IndepYear": 1962, "Population": 31471000}, {"GovernmentForm": "Republic", "GNP": 19770.0, "Code": "ECU", "Name": "Ecuador", "HeadOfState": "Gustavo Noboa Bejarano", "Region": "South America", "Capital": 594, "Code2": "EC", "LifeExpectancy": 71.1, "LocalName": "Ecuador", "SurfaceArea": 283561.0, "GNPOld": 19769.0, "Continent": "South America", "IndepYear": 1822, "Population": 12646000}, {"GovernmentForm": "Republic", "GNP": 82710.0, "Code": "EGY", "Name": "Egypt", "HeadOfState": "Hosni Mubarak", "Region": "Northern Africa", "Capital": 608, "Code2": "EG", "LifeExpectancy": 63.3, "LocalName": "Misr", "SurfaceArea": 1001449.0, "GNPOld": 75617.0, "Continent": "Africa", "IndepYear": 1922, "Population": 68470000}, {"GovernmentForm": "Republic", "GNP": 650.0, "Code": "ERI", "Name": "Eritrea", "HeadOfState": "Isayas Afewerki [Isaias Afwerki]", "Region": "Eastern Africa", "Capital": 652, "Code2": "ER", "LifeExpectancy": 55.8, "LocalName": "Ertra", "SurfaceArea": 117600.0, "GNPOld": 755.0, "Continent": "Africa", "IndepYear": 1993, "Population": 3850000}, {"GovernmentForm": "Occupied by Marocco", "GNP": 60.0, "Code": "ESH", "Name": "Western Sahara", "HeadOfState": "Mohammed Abdel Aziz", "Region": "Northern Africa", "Capital": 2453, "Code2": "EH", "LifeExpectancy": 49.8, "LocalName": "As-Sahrawiya", "SurfaceArea": 266000.0, "GNPOld": null, "Continent": "Africa", "IndepYear": null, "Population": 293000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 553233.0, "Code": "ESP", "Name": "Spain", "HeadOfState": "Juan Carlos I", "Region": "Southern Europe", "Capital": 653, "Code2": "ES", "LifeExpectancy": 78.8, "LocalName": "Espa\\u00f1a", "SurfaceArea": 505992.0, "GNPOld": 532031.0, "Continent": "Europe", "IndepYear": 1492, "Population": 39441700}, {"GovernmentForm": "Republic", "GNP": 5328.0, "Code": "EST", "Name": "Estonia", "HeadOfState": "Lennart Meri", "Region": "Baltic Countries", "Capital": 3791, "Code2": "EE", "LifeExpectancy": 69.5, "LocalName": "Eesti", "SurfaceArea": 45227.0, "GNPOld": 3371.0, "Continent": "Europe", "IndepYear": 1991, "Population": 1439200}, {"GovernmentForm": "Republic", "GNP": 6353.0, "Code": "ETH", "Name": "Ethiopia", "HeadOfState": "Negasso Gidada", "Region": "Eastern Africa", "Capital": 756, "Code2": "ET", "LifeExpectancy": 45.2, "LocalName": "YeItyop\\u00b4iya", "SurfaceArea": 1104300.0, "GNPOld": 6180.0, "Continent": "Africa", "IndepYear": -1000, "Population": 62565000}, {"GovernmentForm": "Republic", "GNP": 121914.0, "Code": "FIN", "Name": "Finland", "HeadOfState": "Tarja Halonen", "Region": "Nordic Countries", "Capital": 3236, "Code2": "FI", "LifeExpectancy": 77.4, "LocalName": "Suomi", "SurfaceArea": 338145.0, "GNPOld": 119833.0, "Continent": "Europe", "IndepYear": 1917, "Population": 5171300}, {"GovernmentForm": "Republic", "GNP": 1536.0, "Code": "FJI", "Name": "Fiji Islands", "HeadOfState": "Josefa Iloilo", "Region": "Melanesia", "Capital": 764, "Code2": "FJ", "LifeExpectancy": 67.9, "LocalName": "Fiji Islands", "SurfaceArea": 18274.0, "GNPOld": 2149.0, "Continent": "Oceania", "IndepYear": 1970, "Population": 817000}, {"GovernmentForm": "Dependent Territory of the UK", "GNP": 0.0, "Code": "FLK", "Name": "Falkland Islands", "HeadOfState": "Elisabeth II", "Region": "South America", "Capital": 763, "Code2": "FK", "LifeExpectancy": null, "LocalName": "Falkland Islands", "SurfaceArea": 12173.0, "GNPOld": null, "Continent": "South America", "IndepYear": null, "Population": 2000}, {"GovernmentForm": "Republic", "GNP": 1424285.0, "Code": "FRA", "Name": "France", "HeadOfState": "Jacques Chirac", "Region": "Western Europe", "Capital": 2974, "Code2": "FR", "LifeExpectancy": 78.8, "LocalName": "France", "SurfaceArea": 551500.0, "GNPOld": 1392448.0, "Continent": "Europe", "IndepYear": 843, "Population": 59225700}, {"GovernmentForm": "Part of Denmark", "GNP": 0.0, "Code": "FRO", "Name": "Faroe Islands", "HeadOfState": "Margrethe II", "Region": "Nordic Countries", "Capital": 901, "Code2": "FO", "LifeExpectancy": 78.4, "LocalName": "F\\u00f8royar", "SurfaceArea": 1399.0, "GNPOld": null, "Continent": "Europe", "IndepYear": null, "Population": 43000}, {"GovernmentForm": "Federal Republic", "GNP": 212.0, "Code": "FSM", "Name": "Micronesia, Federated States of", "HeadOfState": "Leo A. Falcam", "Region": "Micronesia", "Capital": 2689, "Code2": "FM", "LifeExpectancy": 68.6, "LocalName": "Micronesia", "SurfaceArea": 702.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": 1990, "Population": 119000}, {"GovernmentForm": "Republic", "GNP": 5493.0, "Code": "GAB", "Name": "Gabon", "HeadOfState": "Omar Bongo", "Region": "Central Africa", "Capital": 902, "Code2": "GA", "LifeExpectancy": 50.1, "LocalName": "Le Gabon", "SurfaceArea": 267668.0, "GNPOld": 5279.0, "Continent": "Africa", "IndepYear": 1960, "Population": 1226000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 1378330.0, "Code": "GBR", "Name": "United Kingdom", "HeadOfState": "Elisabeth II", "Region": "British Islands", "Capital": 456, "Code2": "GB", "LifeExpectancy": 77.7, "LocalName": "United Kingdom", "SurfaceArea": 242900.0, "GNPOld": 1296830.0, "Continent": "Europe", "IndepYear": 1066, "Population": 59623400}, {"GovernmentForm": "Republic", "GNP": 6064.0, "Code": "GEO", "Name": "Georgia", "HeadOfState": "Eduard \\u0160evardnadze", "Region": "Middle East", "Capital": 905, "Code2": "GE", "LifeExpectancy": 64.5, "LocalName": "Sakartvelo", "SurfaceArea": 69700.0, "GNPOld": 5924.0, "Continent": "Asia", "IndepYear": 1991, "Population": 4968000}, {"GovernmentForm": "Republic", "GNP": 7137.0, "Code": "GHA", "Name": "Ghana", "HeadOfState": "John Kufuor", "Region": "Western Africa", "Capital": 910, "Code2": "GH", "LifeExpectancy": 57.4, "LocalName": "Ghana", "SurfaceArea": 238533.0, "GNPOld": 6884.0, "Continent": "Africa", "IndepYear": 1957, "Population": 20212000}, {"GovernmentForm": "Dependent Territory of the UK", "GNP": 258.0, "Code": "GIB", "Name": "Gibraltar", "HeadOfState": "Elisabeth II", "Region": "Southern Europe", "Capital": 915, "Code2": "GI", "LifeExpectancy": 79.0, "LocalName": "Gibraltar", "SurfaceArea": 6.0, "GNPOld": null, "Continent": "Europe", "IndepYear": null, "Population": 25000}, {"GovernmentForm": "Republic", "GNP": 2352.0, "Code": "GIN", "Name": "Guinea", "HeadOfState": "Lansana Cont\\u00e9", "Region": "Western Africa", "Capital": 926, "Code2": "GN", "LifeExpectancy": 45.6, "LocalName": "Guin\\u00e9e", "SurfaceArea": 245857.0, "GNPOld": 2383.0, "Continent": "Africa", "IndepYear": 1958, "Population": 7430000}, {"GovernmentForm": "Overseas Department of France", "GNP": 3501.0, "Code": "GLP", "Name": "Guadeloupe", "HeadOfState": "Jacques Chirac", "Region": "Caribbean", "Capital": 919, "Code2": "GP", "LifeExpectancy": 77.0, "LocalName": "Guadeloupe", "SurfaceArea": 1705.0, "GNPOld": null, "Continent": "North America", "IndepYear": null, "Population": 456000}, {"GovernmentForm": "Republic", "GNP": 320.0, "Code": "GMB", "Name": "Gambia", "HeadOfState": "Yahya Jammeh", "Region": "Western Africa", "Capital": 904, "Code2": "GM", "LifeExpectancy": 53.2, "LocalName": "The Gambia", "SurfaceArea": 11295.0, "GNPOld": 325.0, "Continent": "Africa", "IndepYear": 1965, "Population": 1305000}, {"GovernmentForm": "Republic", "GNP": 293.0, "Code": "GNB", "Name": "Guinea-Bissau", "HeadOfState": "Kumba Ial\\u00e1", "Region": "Western Africa", "Capital": 927, "Code2": "GW", "LifeExpectancy": 49.0, "LocalName": "Guin\\u00e9-Bissau", "SurfaceArea": 36125.0, "GNPOld": 272.0, "Continent": "Africa", "IndepYear": 1974, "Population": 1213000}, {"GovernmentForm": "Republic", "GNP": 283.0, "Code": "GNQ", "Name": "Equatorial Guinea", "HeadOfState": "Teodoro Obiang Nguema Mbasogo", "Region": "Central Africa", "Capital": 2972, "Code2": "GQ", "LifeExpectancy": 53.6, "LocalName": "Guinea Ecuatorial", "SurfaceArea": 28051.0, "GNPOld": 542.0, "Continent": "Africa", "IndepYear": 1968, "Population": 453000}, {"GovernmentForm": "Republic", "GNP": 120724.0, "Code": "GRC", "Name": "Greece", "HeadOfState": "Kostis Stefanopoulos", "Region": "Southern Europe", "Capital": 2401, "Code2": "GR", "LifeExpectancy": 78.4, "LocalName": "Ell\\u00e1da", "SurfaceArea": 131626.0, "GNPOld": 119946.0, "Continent": "Europe", "IndepYear": 1830, "Population": 10545700}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 318.0, "Code": "GRD", "Name": "Grenada", "HeadOfState": "Elisabeth II", "Region": "Caribbean", "Capital": 916, "Code2": "GD", "LifeExpectancy": 64.5, "LocalName": "Grenada", "SurfaceArea": 344.0, "GNPOld": null, "Continent": "North America", "IndepYear": 1974, "Population": 94000}, {"GovernmentForm": "Part of Denmark", "GNP": 0.0, "Code": "GRL", "Name": "Greenland", "HeadOfState": "Margrethe II", "Region": "North America", "Capital": 917, "Code2": "GL", "LifeExpectancy": 68.1, "LocalName": "Kalaallit Nunaat/Gr\\u00f8nland", "SurfaceArea": 2166090.0, "GNPOld": null, "Continent": "North America", "IndepYear": null, "Population": 56000}, {"GovernmentForm": "Republic", "GNP": 19008.0, "Code": "GTM", "Name": "Guatemala", "HeadOfState": "Alfonso Portillo Cabrera", "Region": "Central America", "Capital": 922, "Code2": "GT", "LifeExpectancy": 66.2, "LocalName": "Guatemala", "SurfaceArea": 108889.0, "GNPOld": 17797.0, "Continent": "North America", "IndepYear": 1821, "Population": 11385000}, {"GovernmentForm": "Overseas Department of France", "GNP": 681.0, "Code": "GUF", "Name": "French Guiana", "HeadOfState": "Jacques Chirac", "Region": "South America", "Capital": 3014, "Code2": "GF", "LifeExpectancy": 76.1, "LocalName": "Guyane fran\\u00e7aise", "SurfaceArea": 90000.0, "GNPOld": null, "Continent": "South America", "IndepYear": null, "Population": 181000}, {"GovernmentForm": "US Territory", "GNP": 1197.0, "Code": "GUM", "Name": "Guam", "HeadOfState": "George W. Bush", "Region": "Micronesia", "Capital": 921, "Code2": "GU", "LifeExpectancy": 77.8, "LocalName": "Guam", "SurfaceArea": 549.0, "GNPOld": 1136.0, "Continent": "Oceania", "IndepYear": null, "Population": 168000}, {"GovernmentForm": "Republic", "GNP": 722.0, "Code": "GUY", "Name": "Guyana", "HeadOfState": "Bharrat Jagdeo", "Region": "South America", "Capital": 928, "Code2": "GY", "LifeExpectancy": 64.0, "LocalName": "Guyana", "SurfaceArea": 214969.0, "GNPOld": 743.0, "Continent": "South America", "IndepYear": 1966, "Population": 861000}, {"GovernmentForm": "Special Administrative Region of China", "GNP": 166448.0, "Code": "HKG", "Name": "Hong Kong", "HeadOfState": "Jiang Zemin", "Region": "Eastern Asia", "Capital": 937, "Code2": "HK", "LifeExpectancy": 79.5, "LocalName": "Xianggang/Hong Kong", "SurfaceArea": 1075.0, "GNPOld": 173610.0, "Continent": "Asia", "IndepYear": null, "Population": 6782000}, {"GovernmentForm": "Territory of Australia", "GNP": 0.0, "Code": "HMD", "Name": "Heard Island and McDonald Islands", "HeadOfState": "Elisabeth II", "Region": "Antarctica", "Capital": null, "Code2": "HM", "LifeExpectancy": null, "LocalName": "Heard and McDonald Islands", "SurfaceArea": 359.0, "GNPOld": null, "Continent": "Antarctica", "IndepYear": null, "Population": 0}, {"GovernmentForm": "Republic", "GNP": 5333.0, "Code": "HND", "Name": "Honduras", "HeadOfState": "Carlos Roberto Flores Facuss\\u00e9", "Region": "Central America", "Capital": 933, "Code2": "HN", "LifeExpectancy": 69.9, "LocalName": "Honduras", "SurfaceArea": 112088.0, "GNPOld": 4697.0, "Continent": "North America", "IndepYear": 1838, "Population": 6485000}, {"GovernmentForm": "Republic", "GNP": 20208.0, "Code": "HRV", "Name": "Croatia", "HeadOfState": "\\u0160tipe Mesic", "Region": "Southern Europe", "Capital": 2409, "Code2": "HR", "LifeExpectancy": 73.7, "LocalName": "Hrvatska", "SurfaceArea": 56538.0, "GNPOld": 19300.0, "Continent": "Europe", "IndepYear": 1991, "Population": 4473000}, {"GovernmentForm": "Republic", "GNP": 3459.0, "Code": "HTI", "Name": "Haiti", "HeadOfState": "Jean-Bertrand Aristide", "Region": "Caribbean", "Capital": 929, "Code2": "HT", "LifeExpectancy": 49.2, "LocalName": "Ha\\u00efti/Dayti", "SurfaceArea": 27750.0, "GNPOld": 3107.0, "Continent": "North America", "IndepYear": 1804, "Population": 8222000}, {"GovernmentForm": "Republic", "GNP": 48267.0, "Code": "HUN", "Name": "Hungary", "HeadOfState": "Ferenc M\\u00e1dl", "Region": "Eastern Europe", "Capital": 3483, "Code2": "HU", "LifeExpectancy": 71.4, "LocalName": "Magyarorsz\\u00e1g", "SurfaceArea": 93030.0, "GNPOld": 45914.0, "Continent": "Europe", "IndepYear": 1918, "Population": 10043200}, {"GovernmentForm": "Republic", "GNP": 84982.0, "Code": "IDN", "Name": "Indonesia", "HeadOfState": "Abdurrahman Wahid", "Region": "Southeast Asia", "Capital": 939, "Code2": "ID", "LifeExpectancy": 68.0, "LocalName": "Indonesia", "SurfaceArea": 1904569.0, "GNPOld": 215002.0, "Continent": "Asia", "IndepYear": 1945, "Population": 212107000}, {"GovernmentForm": "Federal Republic", "GNP": 447114.0, "Code": "IND", "Name": "India", "HeadOfState": "Kocheril Raman Narayanan", "Region": "Southern and Central Asia", "Capital": 1109, "Code2": "IN", "LifeExpectancy": 62.5, "LocalName": "Bharat/India", "SurfaceArea": 3287263.0, "GNPOld": 430572.0, "Continent": "Asia", "IndepYear": 1947, "Population": 1013662000}, {"GovernmentForm": "Dependent Territory of the UK", "GNP": 0.0, "Code": "IOT", "Name": "British Indian Ocean Territory", "HeadOfState": "Elisabeth II", "Region": "Eastern Africa", "Capital": null, "Code2": "IO", "LifeExpectancy": null, "LocalName": "British Indian Ocean Territory", "SurfaceArea": 78.0, "GNPOld": null, "Continent": "Africa", "IndepYear": null, "Population": 0}, {"GovernmentForm": "Republic", "GNP": 75921.0, "Code": "IRL", "Name": "Ireland", "HeadOfState": "Mary McAleese", "Region": "British Islands", "Capital": 1447, "Code2": "IE", "LifeExpectancy": 76.8, "LocalName": "Ireland/\\u00c9ire", "SurfaceArea": 70273.0, "GNPOld": 73132.0, "Continent": "Europe", "IndepYear": 1921, "Population": 3775100}, {"GovernmentForm": "Islamic Republic", "GNP": 195746.0, "Code": "IRN", "Name": "Iran", "HeadOfState": "Ali Mohammad Khatami-Ardakani", "Region": "Southern and Central Asia", "Capital": 1380, "Code2": "IR", "LifeExpectancy": 69.7, "LocalName": "Iran", "SurfaceArea": 1648195.0, "GNPOld": 160151.0, "Continent": "Asia", "IndepYear": 1906, "Population": 67702000}, {"GovernmentForm": "Republic", "GNP": 11500.0, "Code": "IRQ", "Name": "Iraq", "HeadOfState": "Saddam Hussein al-Takriti", "Region": "Middle East", "Capital": 1365, "Code2": "IQ", "LifeExpectancy": 66.5, "LocalName": "Al-\\u00b4Iraq", "SurfaceArea": 438317.0, "GNPOld": null, "Continent": "Asia", "IndepYear": 1932, "Population": 23115000}, {"GovernmentForm": "Republic", "GNP": 8255.0, "Code": "ISL", "Name": "Iceland", "HeadOfState": "\\u00d3lafur Ragnar Gr\\u00edmsson", "Region": "Nordic Countries", "Capital": 1449, "Code2": "IS", "LifeExpectancy": 79.4, "LocalName": "\\u00cdsland", "SurfaceArea": 103000.0, "GNPOld": 7474.0, "Continent": "Europe", "IndepYear": 1944, "Population": 279000}, {"GovernmentForm": "Republic", "GNP": 97477.0, "Code": "ISR", "Name": "Israel", "HeadOfState": "Moshe Katzav", "Region": "Middle East", "Capital": 1450, "Code2": "IL", "LifeExpectancy": 78.6, "LocalName": "Yisra\\u2019el/Isra\\u2019il", "SurfaceArea": 21056.0, "GNPOld": 98577.0, "Continent": "Asia", "IndepYear": 1948, "Population": 6217000}, {"GovernmentForm": "Republic", "GNP": 1161755.0, "Code": "ITA", "Name": "Italy", "HeadOfState": "Carlo Azeglio Ciampi", "Region": "Southern Europe", "Capital": 1464, "Code2": "IT", "LifeExpectancy": 79.0, "LocalName": "Italia", "SurfaceArea": 301316.0, "GNPOld": 1145372.0, "Continent": "Europe", "IndepYear": 1861, "Population": 57680000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 6871.0, "Code": "JAM", "Name": "Jamaica", "HeadOfState": "Elisabeth II", "Region": "Caribbean", "Capital": 1530, "Code2": "JM", "LifeExpectancy": 75.2, "LocalName": "Jamaica", "SurfaceArea": 10990.0, "GNPOld": 6722.0, "Continent": "North America", "IndepYear": 1962, "Population": 2583000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 7526.0, "Code": "JOR", "Name": "Jordan", "HeadOfState": "Abdullah II", "Region": "Middle East", "Capital": 1786, "Code2": "JO", "LifeExpectancy": 77.4, "LocalName": "Al-Urdunn", "SurfaceArea": 88946.0, "GNPOld": 7051.0, "Continent": "Asia", "IndepYear": 1946, "Population": 5083000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 3787042.0, "Code": "JPN", "Name": "Japan", "HeadOfState": "Akihito", "Region": "Eastern Asia", "Capital": 1532, "Code2": "JP", "LifeExpectancy": 80.7, "LocalName": "Nihon/Nippon", "SurfaceArea": 377829.0, "GNPOld": 4192638.0, "Continent": "Asia", "IndepYear": -660, "Population": 126714000}, {"GovernmentForm": "Republic", "GNP": 24375.0, "Code": "KAZ", "Name": "Kazakstan", "HeadOfState": "Nursultan Nazarbajev", "Region": "Southern and Central Asia", "Capital": 1864, "Code2": "KZ", "LifeExpectancy": 63.2, "LocalName": "Qazaqstan", "SurfaceArea": 2724900.0, "GNPOld": 23383.0, "Continent": "Asia", "IndepYear": 1991, "Population": 16223000}, {"GovernmentForm": "Republic", "GNP": 9217.0, "Code": "KEN", "Name": "Kenya", "HeadOfState": "Daniel arap Moi", "Region": "Eastern Africa", "Capital": 1881, "Code2": "KE", "LifeExpectancy": 48.0, "LocalName": "Kenya", "SurfaceArea": 580367.0, "GNPOld": 10241.0, "Continent": "Africa", "IndepYear": 1963, "Population": 30080000}, {"GovernmentForm": "Republic", "GNP": 1626.0, "Code": "KGZ", "Name": "Kyrgyzstan", "HeadOfState": "Askar Akajev", "Region": "Southern and Central Asia", "Capital": 2253, "Code2": "KG", "LifeExpectancy": 63.4, "LocalName": "Kyrgyzstan", "SurfaceArea": 199900.0, "GNPOld": 1767.0, "Continent": "Asia", "IndepYear": 1991, "Population": 4699000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 5121.0, "Code": "KHM", "Name": "Cambodia", "HeadOfState": "Norodom Sihanouk", "Region": "Southeast Asia", "Capital": 1800, "Code2": "KH", "LifeExpectancy": 56.5, "LocalName": "K\\u00e2mpuch\\u00e9a", "SurfaceArea": 181035.0, "GNPOld": 5670.0, "Continent": "Asia", "IndepYear": 1953, "Population": 11168000}, {"GovernmentForm": "Republic", "GNP": 40.7, "Code": "KIR", "Name": "Kiribati", "HeadOfState": "Teburoro Tito", "Region": "Micronesia", "Capital": 2256, "Code2": "KI", "LifeExpectancy": 59.8, "LocalName": "Kiribati", "SurfaceArea": 726.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": 1979, "Population": 83000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 299.0, "Code": "KNA", "Name": "Saint Kitts and Nevis", "HeadOfState": "Elisabeth II", "Region": "Caribbean", "Capital": 3064, "Code2": "KN", "LifeExpectancy": 70.7, "LocalName": "Saint Kitts and Nevis", "SurfaceArea": 261.0, "GNPOld": null, "Continent": "North America", "IndepYear": 1983, "Population": 38000}, {"GovernmentForm": "Republic", "GNP": 320749.0, "Code": "KOR", "Name": "South Korea", "HeadOfState": "Kim Dae-jung", "Region": "Eastern Asia", "Capital": 2331, "Code2": "KR", "LifeExpectancy": 74.4, "LocalName": "Taehan Min\\u2019guk (Namhan)", "SurfaceArea": 99434.0, "GNPOld": 442544.0, "Continent": "Asia", "IndepYear": 1948, "Population": 46844000}, {"GovernmentForm": "Constitutional Monarchy (Emirate)", "GNP": 27037.0, "Code": "KWT", "Name": "Kuwait", "HeadOfState": "Jabir al-Ahmad al-Jabir al-Sabah", "Region": "Middle East", "Capital": 2429, "Code2": "KW", "LifeExpectancy": 76.1, "LocalName": "Al-Kuwayt", "SurfaceArea": 17818.0, "GNPOld": 30373.0, "Continent": "Asia", "IndepYear": 1961, "Population": 1972000}, {"GovernmentForm": "Republic", "GNP": 1292.0, "Code": "LAO", "Name": "Laos", "HeadOfState": "Khamtay Siphandone", "Region": "Southeast Asia", "Capital": 2432, "Code2": "LA", "LifeExpectancy": 53.1, "LocalName": "Lao", "SurfaceArea": 236800.0, "GNPOld": 1746.0, "Continent": "Asia", "IndepYear": 1953, "Population": 5433000}, {"GovernmentForm": "Republic", "GNP": 17121.0, "Code": "LBN", "Name": "Lebanon", "HeadOfState": "\\u00c9mile Lahoud", "Region": "Middle East", "Capital": 2438, "Code2": "LB", "LifeExpectancy": 71.3, "LocalName": "Lubnan", "SurfaceArea": 10400.0, "GNPOld": 15129.0, "Continent": "Asia", "IndepYear": 1941, "Population": 3282000}, {"GovernmentForm": "Republic", "GNP": 2012.0, "Code": "LBR", "Name": "Liberia", "HeadOfState": "Charles Taylor", "Region": "Western Africa", "Capital": 2440, "Code2": "LR", "LifeExpectancy": 51.0, "LocalName": "Liberia", "SurfaceArea": 111369.0, "GNPOld": null, "Continent": "Africa", "IndepYear": 1847, "Population": 3154000}, {"GovernmentForm": "Socialistic State", "GNP": 44806.0, "Code": "LBY", "Name": "Libyan Arab Jamahiriya", "HeadOfState": "Muammar al-Qadhafi", "Region": "Northern Africa", "Capital": 2441, "Code2": "LY", "LifeExpectancy": 75.5, "LocalName": "Libiya", "SurfaceArea": 1759540.0, "GNPOld": 40562.0, "Continent": "Africa", "IndepYear": 1951, "Population": 5605000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 571.0, "Code": "LCA", "Name": "Saint Lucia", "HeadOfState": "Elisabeth II", "Region": "Caribbean", "Capital": 3065, "Code2": "LC", "LifeExpectancy": 72.3, "LocalName": "Saint Lucia", "SurfaceArea": 622.0, "GNPOld": null, "Continent": "North America", "IndepYear": 1979, "Population": 154000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 1119.0, "Code": "LIE", "Name": "Liechtenstein", "HeadOfState": "Hans-Adam II", "Region": "Western Europe", "Capital": 2446, "Code2": "LI", "LifeExpectancy": 78.8, "LocalName": "Liechtenstein", "SurfaceArea": 160.0, "GNPOld": 1084.0, "Continent": "Europe", "IndepYear": 1806, "Population": 32300}, {"GovernmentForm": "Republic", "GNP": 15706.0, "Code": "LKA", "Name": "Sri Lanka", "HeadOfState": "Chandrika Kumaratunga", "Region": "Southern and Central Asia", "Capital": 3217, "Code2": "LK", "LifeExpectancy": 71.8, "LocalName": "Sri Lanka/Ilankai", "SurfaceArea": 65610.0, "GNPOld": 15091.0, "Continent": "Asia", "IndepYear": 1948, "Population": 18827000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 1061.0, "Code": "LSO", "Name": "Lesotho", "HeadOfState": "Letsie III", "Region": "Southern Africa", "Capital": 2437, "Code2": "LS", "LifeExpectancy": 50.8, "LocalName": "Lesotho", "SurfaceArea": 30355.0, "GNPOld": 1161.0, "Continent": "Africa", "IndepYear": 1966, "Population": 2153000}, {"GovernmentForm": "Republic", "GNP": 10692.0, "Code": "LTU", "Name": "Lithuania", "HeadOfState": "Valdas Adamkus", "Region": "Baltic Countries", "Capital": 2447, "Code2": "LT", "LifeExpectancy": 69.1, "LocalName": "Lietuva", "SurfaceArea": 65301.0, "GNPOld": 9585.0, "Continent": "Europe", "IndepYear": 1991, "Population": 3698500}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 16321.0, "Code": "LUX", "Name": "Luxembourg", "HeadOfState": "Henri", "Region": "Western Europe", "Capital": 2452, "Code2": "LU", "LifeExpectancy": 77.1, "LocalName": "Luxembourg/L\\u00ebtzebuerg", "SurfaceArea": 2586.0, "GNPOld": 15519.0, "Continent": "Europe", "IndepYear": 1867, "Population": 435700}, {"GovernmentForm": "Republic", "GNP": 6398.0, "Code": "LVA", "Name": "Latvia", "HeadOfState": "Vaira Vike-Freiberga", "Region": "Baltic Countries", "Capital": 2434, "Code2": "LV", "LifeExpectancy": 68.4, "LocalName": "Latvija", "SurfaceArea": 64589.0, "GNPOld": 5639.0, "Continent": "Europe", "IndepYear": 1991, "Population": 2424200}, {"GovernmentForm": "Special Administrative Region of China", "GNP": 5749.0, "Code": "MAC", "Name": "Macao", "HeadOfState": "Jiang Zemin", "Region": "Eastern Asia", "Capital": 2454, "Code2": "MO", "LifeExpectancy": 81.6, "LocalName": "Macau/Aomen", "SurfaceArea": 18.0, "GNPOld": 5940.0, "Continent": "Asia", "IndepYear": null, "Population": 473000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 36124.0, "Code": "MAR", "Name": "Morocco", "HeadOfState": "Mohammed VI", "Region": "Northern Africa", "Capital": 2486, "Code2": "MA", "LifeExpectancy": 69.1, "LocalName": "Al-Maghrib", "SurfaceArea": 446550.0, "GNPOld": 33514.0, "Continent": "Africa", "IndepYear": 1956, "Population": 28351000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 776.0, "Code": "MCO", "Name": "Monaco", "HeadOfState": "Rainier III", "Region": "Western Europe", "Capital": 2695, "Code2": "MC", "LifeExpectancy": 78.8, "LocalName": "Monaco", "SurfaceArea": 1.5, "GNPOld": null, "Continent": "Europe", "IndepYear": 1861, "Population": 34000}, {"GovernmentForm": "Republic", "GNP": 1579.0, "Code": "MDA", "Name": "Moldova", "HeadOfState": "Vladimir Voronin", "Region": "Eastern Europe", "Capital": 2690, "Code2": "MD", "LifeExpectancy": 64.5, "LocalName": "Moldova", "SurfaceArea": 33851.0, "GNPOld": 1872.0, "Continent": "Europe", "IndepYear": 1991, "Population": 4380000}, {"GovernmentForm": "Federal Republic", "GNP": 3750.0, "Code": "MDG", "Name": "Madagascar", "HeadOfState": "Didier Ratsiraka", "Region": "Eastern Africa", "Capital": 2455, "Code2": "MG", "LifeExpectancy": 55.0, "LocalName": "Madagasikara/Madagascar", "SurfaceArea": 587041.0, "GNPOld": 3545.0, "Continent": "Africa", "IndepYear": 1960, "Population": 15942000}, {"GovernmentForm": "Republic", "GNP": 199.0, "Code": "MDV", "Name": "Maldives", "HeadOfState": "Maumoon Abdul Gayoom", "Region": "Southern and Central Asia", "Capital": 2463, "Code2": "MV", "LifeExpectancy": 62.2, "LocalName": "Dhivehi Raajje/Maldives", "SurfaceArea": 298.0, "GNPOld": null, "Continent": "Asia", "IndepYear": 1965, "Population": 286000}, {"GovernmentForm": "Federal Republic", "GNP": 414972.0, "Code": "MEX", "Name": "Mexico", "HeadOfState": "Vicente Fox Quesada", "Region": "Central America", "Capital": 2515, "Code2": "MX", "LifeExpectancy": 71.5, "LocalName": "M\\u00e9xico", "SurfaceArea": 1958201.0, "GNPOld": 401461.0, "Continent": "North America", "IndepYear": 1810, "Population": 98881000}, {"GovernmentForm": "Republic", "GNP": 97.0, "Code": "MHL", "Name": "Marshall Islands", "HeadOfState": "Kessai Note", "Region": "Micronesia", "Capital": 2507, "Code2": "MH", "LifeExpectancy": 65.5, "LocalName": "Marshall Islands/Majol", "SurfaceArea": 181.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": 1990, "Population": 64000}, {"GovernmentForm": "Republic", "GNP": 1694.0, "Code": "MKD", "Name": "Macedonia", "HeadOfState": "Boris Trajkovski", "Region": "Southern Europe", "Capital": 2460, "Code2": "MK", "LifeExpectancy": 73.8, "LocalName": "Makedonija", "SurfaceArea": 25713.0, "GNPOld": 1915.0, "Continent": "Europe", "IndepYear": 1991, "Population": 2024000}, {"GovernmentForm": "Republic", "GNP": 2642.0, "Code": "MLI", "Name": "Mali", "HeadOfState": "Alpha Oumar Konar\\u00e9", "Region": "Western Africa", "Capital": 2482, "Code2": "ML", "LifeExpectancy": 46.7, "LocalName": "Mali", "SurfaceArea": 1240192.0, "GNPOld": 2453.0, "Continent": "Africa", "IndepYear": 1960, "Population": 11234000}, {"GovernmentForm": "Republic", "GNP": 3512.0, "Code": "MLT", "Name": "Malta", "HeadOfState": "Guido de Marco", "Region": "Southern Europe", "Capital": 2484, "Code2": "MT", "LifeExpectancy": 77.9, "LocalName": "Malta", "SurfaceArea": 316.0, "GNPOld": 3338.0, "Continent": "Europe", "IndepYear": 1964, "Population": 380200}, {"GovernmentForm": "Republic", "GNP": 180375.0, "Code": "MMR", "Name": "Myanmar", "HeadOfState": "kenraali Than Shwe", "Region": "Southeast Asia", "Capital": 2710, "Code2": "MM", "LifeExpectancy": 54.9, "LocalName": "Myanma Pye", "SurfaceArea": 676578.0, "GNPOld": 171028.0, "Continent": "Asia", "IndepYear": 1948, "Population": 45611000}, {"GovernmentForm": "Republic", "GNP": 1043.0, "Code": "MNG", "Name": "Mongolia", "HeadOfState": "Natsagiin Bagabandi", "Region": "Eastern Asia", "Capital": 2696, "Code2": "MN", "LifeExpectancy": 67.3, "LocalName": "Mongol Uls", "SurfaceArea": 1566500.0, "GNPOld": 933.0, "Continent": "Asia", "IndepYear": 1921, "Population": 2662000}, {"GovernmentForm": "Commonwealth of the US", "GNP": 0.0, "Code": "MNP", "Name": "Northern Mariana Islands", "HeadOfState": "George W. Bush", "Region": "Micronesia", "Capital": 2913, "Code2": "MP", "LifeExpectancy": 75.5, "LocalName": "Northern Mariana Islands", "SurfaceArea": 464.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": null, "Population": 78000}, {"GovernmentForm": "Republic", "GNP": 2891.0, "Code": "MOZ", "Name": "Mozambique", "HeadOfState": "Joaqu\\u00edm A. Chissano", "Region": "Eastern Africa", "Capital": 2698, "Code2": "MZ", "LifeExpectancy": 37.5, "LocalName": "Mo\\u00e7ambique", "SurfaceArea": 801590.0, "GNPOld": 2711.0, "Continent": "Africa", "IndepYear": 1975, "Population": 19680000}, {"GovernmentForm": "Republic", "GNP": 998.0, "Code": "MRT", "Name": "Mauritania", "HeadOfState": "Maaouiya Ould Sid\\u00b4Ahmad Taya", "Region": "Western Africa", "Capital": 2509, "Code2": "MR", "LifeExpectancy": 50.8, "LocalName": "Muritaniya/Mauritanie", "SurfaceArea": 1025520.0, "GNPOld": 1081.0, "Continent": "Africa", "IndepYear": 1960, "Population": 2670000}, {"GovernmentForm": "Dependent Territory of the UK", "GNP": 109.0, "Code": "MSR", "Name": "Montserrat", "HeadOfState": "Elisabeth II", "Region": "Caribbean", "Capital": 2697, "Code2": "MS", "LifeExpectancy": 78.0, "LocalName": "Montserrat", "SurfaceArea": 102.0, "GNPOld": null, "Continent": "North America", "IndepYear": null, "Population": 11000}, {"GovernmentForm": "Overseas Department of France", "GNP": 2731.0, "Code": "MTQ", "Name": "Martinique", "HeadOfState": "Jacques Chirac", "Region": "Caribbean", "Capital": 2508, "Code2": "MQ", "LifeExpectancy": 78.3, "LocalName": "Martinique", "SurfaceArea": 1102.0, "GNPOld": 2559.0, "Continent": "North America", "IndepYear": null, "Population": 395000}, {"GovernmentForm": "Republic", "GNP": 4251.0, "Code": "MUS", "Name": "Mauritius", "HeadOfState": "Cassam Uteem", "Region": "Eastern Africa", "Capital": 2511, "Code2": "MU", "LifeExpectancy": 71.0, "LocalName": "Mauritius", "SurfaceArea": 2040.0, "GNPOld": 4186.0, "Continent": "Africa", "IndepYear": 1968, "Population": 1158000}, {"GovernmentForm": "Republic", "GNP": 1687.0, "Code": "MWI", "Name": "Malawi", "HeadOfState": "Bakili Muluzi", "Region": "Eastern Africa", "Capital": 2462, "Code2": "MW", "LifeExpectancy": 37.6, "LocalName": "Malawi", "SurfaceArea": 118484.0, "GNPOld": 2527.0, "Continent": "Africa", "IndepYear": 1964, "Population": 10925000}, {"GovernmentForm": "Constitutional Monarchy, Federation", "GNP": 69213.0, "Code": "MYS", "Name": "Malaysia", "HeadOfState": "Salahuddin Abdul Aziz Shah Alhaj", "Region": "Southeast Asia", "Capital": 2464, "Code2": "MY", "LifeExpectancy": 70.8, "LocalName": "Malaysia", "SurfaceArea": 329758.0, "GNPOld": 97884.0, "Continent": "Asia", "IndepYear": 1957, "Population": 22244000}, {"GovernmentForm": "Territorial Collectivity of France", "GNP": 0.0, "Code": "MYT", "Name": "Mayotte", "HeadOfState": "Jacques Chirac", "Region": "Eastern Africa", "Capital": 2514, "Code2": "YT", "LifeExpectancy": 59.5, "LocalName": "Mayotte", "SurfaceArea": 373.0, "GNPOld": null, "Continent": "Africa", "IndepYear": null, "Population": 149000}, {"GovernmentForm": "Republic", "GNP": 3101.0, "Code": "NAM", "Name": "Namibia", "HeadOfState": "Sam Nujoma", "Region": "Southern Africa", "Capital": 2726, "Code2": "NA", "LifeExpectancy": 42.5, "LocalName": "Namibia", "SurfaceArea": 824292.0, "GNPOld": 3384.0, "Continent": "Africa", "IndepYear": 1990, "Population": 1726000}, {"GovernmentForm": "Nonmetropolitan Territory of France", "GNP": 3563.0, "Code": "NCL", "Name": "New Caledonia", "HeadOfState": "Jacques Chirac", "Region": "Melanesia", "Capital": 3493, "Code2": "NC", "LifeExpectancy": 72.8, "LocalName": "Nouvelle-Cal\\u00e9donie", "SurfaceArea": 18575.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": null, "Population": 214000}, {"GovernmentForm": "Republic", "GNP": 1706.0, "Code": "NER", "Name": "Niger", "HeadOfState": "Mamadou Tandja", "Region": "Western Africa", "Capital": 2738, "Code2": "NE", "LifeExpectancy": 41.3, "LocalName": "Niger", "SurfaceArea": 1267000.0, "GNPOld": 1580.0, "Continent": "Africa", "IndepYear": 1960, "Population": 10730000}, {"GovernmentForm": "Territory of Australia", "GNP": 0.0, "Code": "NFK", "Name": "Norfolk Island", "HeadOfState": "Elisabeth II", "Region": "Australia and New Zealand", "Capital": 2806, "Code2": "NF", "LifeExpectancy": null, "LocalName": "Norfolk Island", "SurfaceArea": 36.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": null, "Population": 2000}, {"GovernmentForm": "Federal Republic", "GNP": 65707.0, "Code": "NGA", "Name": "Nigeria", "HeadOfState": "Olusegun Obasanjo", "Region": "Western Africa", "Capital": 2754, "Code2": "NG", "LifeExpectancy": 51.6, "LocalName": "Nigeria", "SurfaceArea": 923768.0, "GNPOld": 58623.0, "Continent": "Africa", "IndepYear": 1960, "Population": 111506000}, {"GovernmentForm": "Republic", "GNP": 1988.0, "Code": "NIC", "Name": "Nicaragua", "HeadOfState": "Arnoldo Alem\\u00e1n Lacayo", "Region": "Central America", "Capital": 2734, "Code2": "NI", "LifeExpectancy": 68.7, "LocalName": "Nicaragua", "SurfaceArea": 130000.0, "GNPOld": 2023.0, "Continent": "North America", "IndepYear": 1838, "Population": 5074000}, {"GovernmentForm": "Nonmetropolitan Territory of New Zealand", "GNP": 0.0, "Code": "NIU", "Name": "Niue", "HeadOfState": "Elisabeth II", "Region": "Polynesia", "Capital": 2805, "Code2": "NU", "LifeExpectancy": null, "LocalName": "Niue", "SurfaceArea": 260.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": null, "Population": 2000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 371362.0, "Code": "NLD", "Name": "Netherlands", "HeadOfState": "Beatrix", "Region": "Western Europe", "Capital": 5, "Code2": "NL", "LifeExpectancy": 78.3, "LocalName": "Nederland", "SurfaceArea": 41526.0, "GNPOld": 360478.0, "Continent": "Europe", "IndepYear": 1581, "Population": 15864000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 145895.0, "Code": "NOR", "Name": "Norway", "HeadOfState": "Harald V", "Region": "Nordic Countries", "Capital": 2807, "Code2": "NO", "LifeExpectancy": 78.7, "LocalName": "Norge", "SurfaceArea": 323877.0, "GNPOld": 153370.0, "Continent": "Europe", "IndepYear": 1905, "Population": 4478500}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 4768.0, "Code": "NPL", "Name": "Nepal", "HeadOfState": "Gyanendra Bir Bikram", "Region": "Southern and Central Asia", "Capital": 2729, "Code2": "NP", "LifeExpectancy": 57.8, "LocalName": "Nepal", "SurfaceArea": 147181.0, "GNPOld": 4837.0, "Continent": "Asia", "IndepYear": 1769, "Population": 23930000}, {"GovernmentForm": "Republic", "GNP": 197.0, "Code": "NRU", "Name": "Nauru", "HeadOfState": "Bernard Dowiyogo", "Region": "Micronesia", "Capital": 2728, "Code2": "NR", "LifeExpectancy": 60.8, "LocalName": "Naoero/Nauru", "SurfaceArea": 21.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": 1968, "Population": 12000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 54669.0, "Code": "NZL", "Name": "New Zealand", "HeadOfState": "Elisabeth II", "Region": "Australia and New Zealand", "Capital": 3499, "Code2": "NZ", "LifeExpectancy": 77.8, "LocalName": "New Zealand/Aotearoa", "SurfaceArea": 270534.0, "GNPOld": 64960.0, "Continent": "Oceania", "IndepYear": 1907, "Population": 3862000}, {"GovernmentForm": "Monarchy (Sultanate)", "GNP": 16904.0, "Code": "OMN", "Name": "Oman", "HeadOfState": "Qabus ibn Sa\\u00b4id", "Region": "Middle East", "Capital": 2821, "Code2": "OM", "LifeExpectancy": 71.8, "LocalName": "\\u00b4Uman", "SurfaceArea": 309500.0, "GNPOld": 16153.0, "Continent": "Asia", "IndepYear": 1951, "Population": 2542000}, {"GovernmentForm": "Republic", "GNP": 61289.0, "Code": "PAK", "Name": "Pakistan", "HeadOfState": "Mohammad Rafiq Tarar", "Region": "Southern and Central Asia", "Capital": 2831, "Code2": "PK", "LifeExpectancy": 61.1, "LocalName": "Pakistan", "SurfaceArea": 796095.0, "GNPOld": 58549.0, "Continent": "Asia", "IndepYear": 1947, "Population": 156483000}, {"GovernmentForm": "Republic", "GNP": 9131.0, "Code": "PAN", "Name": "Panama", "HeadOfState": "Mireya Elisa Moscoso Rodr\\u00edguez", "Region": "Central America", "Capital": 2882, "Code2": "PA", "LifeExpectancy": 75.5, "LocalName": "Panam\\u00e1", "SurfaceArea": 75517.0, "GNPOld": 8700.0, "Continent": "North America", "IndepYear": 1903, "Population": 2856000}, {"GovernmentForm": "Dependent Territory of the UK", "GNP": 0.0, "Code": "PCN", "Name": "Pitcairn", "HeadOfState": "Elisabeth II", "Region": "Polynesia", "Capital": 2912, "Code2": "PN", "LifeExpectancy": null, "LocalName": "Pitcairn", "SurfaceArea": 49.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": null, "Population": 50}, {"GovernmentForm": "Republic", "GNP": 64140.0, "Code": "PER", "Name": "Peru", "HeadOfState": "Valentin Paniagua Corazao", "Region": "South America", "Capital": 2890, "Code2": "PE", "LifeExpectancy": 70.0, "LocalName": "Per\\u00fa/Piruw", "SurfaceArea": 1285216.0, "GNPOld": 65186.0, "Continent": "South America", "IndepYear": 1821, "Population": 25662000}, {"GovernmentForm": "Republic", "GNP": 65107.0, "Code": "PHL", "Name": "Philippines", "HeadOfState": "Gloria Macapagal-Arroyo", "Region": "Southeast Asia", "Capital": 766, "Code2": "PH", "LifeExpectancy": 67.5, "LocalName": "Pilipinas", "SurfaceArea": 300000.0, "GNPOld": 82239.0, "Continent": "Asia", "IndepYear": 1946, "Population": 75967000}, {"GovernmentForm": "Republic", "GNP": 105.0, "Code": "PLW", "Name": "Palau", "HeadOfState": "Kuniwo Nakamura", "Region": "Micronesia", "Capital": 2881, "Code2": "PW", "LifeExpectancy": 68.6, "LocalName": "Belau/Palau", "SurfaceArea": 459.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": 1994, "Population": 19000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 4988.0, "Code": "PNG", "Name": "Papua New Guinea", "HeadOfState": "Elisabeth II", "Region": "Melanesia", "Capital": 2884, "Code2": "PG", "LifeExpectancy": 63.1, "LocalName": "Papua New Guinea/Papua Niugini", "SurfaceArea": 462840.0, "GNPOld": 6328.0, "Continent": "Oceania", "IndepYear": 1975, "Population": 4807000}, {"GovernmentForm": "Republic", "GNP": 151697.0, "Code": "POL", "Name": "Poland", "HeadOfState": "Aleksander Kwasniewski", "Region": "Eastern Europe", "Capital": 2928, "Code2": "PL", "LifeExpectancy": 73.2, "LocalName": "Polska", "SurfaceArea": 323250.0, "GNPOld": 135636.0, "Continent": "Europe", "IndepYear": 1918, "Population": 38653600}, {"GovernmentForm": "Commonwealth of the US", "GNP": 34100.0, "Code": "PRI", "Name": "Puerto Rico", "HeadOfState": "George W. Bush", "Region": "Caribbean", "Capital": 2919, "Code2": "PR", "LifeExpectancy": 75.6, "LocalName": "Puerto Rico", "SurfaceArea": 8875.0, "GNPOld": 32100.0, "Continent": "North America", "IndepYear": null, "Population": 3869000}, {"GovernmentForm": "Socialistic Republic", "GNP": 5332.0, "Code": "PRK", "Name": "North Korea", "HeadOfState": "Kim Jong-il", "Region": "Eastern Asia", "Capital": 2318, "Code2": "KP", "LifeExpectancy": 70.7, "LocalName": "Choson Minjujuui In\\u00b4min Konghwaguk (Bukhan)", "SurfaceArea": 120538.0, "GNPOld": null, "Continent": "Asia", "IndepYear": 1948, "Population": 24039000}, {"GovernmentForm": "Republic", "GNP": 105954.0, "Code": "PRT", "Name": "Portugal", "HeadOfState": "Jorge Samp\\u00e3io", "Region": "Southern Europe", "Capital": 2914, "Code2": "PT", "LifeExpectancy": 75.8, "LocalName": "Portugal", "SurfaceArea": 91982.0, "GNPOld": 102133.0, "Continent": "Europe", "IndepYear": 1143, "Population": 9997600}, {"GovernmentForm": "Republic", "GNP": 8444.0, "Code": "PRY", "Name": "Paraguay", "HeadOfState": "Luis \\u00c1ngel Gonz\\u00e1lez Macchi", "Region": "South America", "Capital": 2885, "Code2": "PY", "LifeExpectancy": 73.7, "LocalName": "Paraguay", "SurfaceArea": 406752.0, "GNPOld": 9555.0, "Continent": "South America", "IndepYear": 1811, "Population": 5496000}, {"GovernmentForm": "Autonomous Area", "GNP": 4173.0, "Code": "PSE", "Name": "Palestine", "HeadOfState": "Yasser (Yasir) Arafat", "Region": "Middle East", "Capital": 4074, "Code2": "PS", "LifeExpectancy": 71.4, "LocalName": "Filastin", "SurfaceArea": 6257.0, "GNPOld": null, "Continent": "Asia", "IndepYear": null, "Population": 3101000}, {"GovernmentForm": "Nonmetropolitan Territory of France", "GNP": 818.0, "Code": "PYF", "Name": "French Polynesia", "HeadOfState": "Jacques Chirac", "Region": "Polynesia", "Capital": 3016, "Code2": "PF", "LifeExpectancy": 74.8, "LocalName": "Polyn\\u00e9sie fran\\u00e7aise", "SurfaceArea": 4000.0, "GNPOld": 781.0, "Continent": "Oceania", "IndepYear": null, "Population": 235000}, {"GovernmentForm": "Monarchy", "GNP": 9472.0, "Code": "QAT", "Name": "Qatar", "HeadOfState": "Hamad ibn Khalifa al-Thani", "Region": "Middle East", "Capital": 2973, "Code2": "QA", "LifeExpectancy": 72.4, "LocalName": "Qatar", "SurfaceArea": 11000.0, "GNPOld": 8920.0, "Continent": "Asia", "IndepYear": 1971, "Population": 599000}, {"GovernmentForm": "Overseas Department of France", "GNP": 8287.0, "Code": "REU", "Name": "R\\u00e9union", "HeadOfState": "Jacques Chirac", "Region": "Eastern Africa", "Capital": 3017, "Code2": "RE", "LifeExpectancy": 72.7, "LocalName": "R\\u00e9union", "SurfaceArea": 2510.0, "GNPOld": 7988.0, "Continent": "Africa", "IndepYear": null, "Population": 699000}, {"GovernmentForm": "Republic", "GNP": 38158.0, "Code": "ROM", "Name": "Romania", "HeadOfState": "Ion Iliescu", "Region": "Eastern Europe", "Capital": 3018, "Code2": "RO", "LifeExpectancy": 69.9, "LocalName": "Rom\\u00e2nia", "SurfaceArea": 238391.0, "GNPOld": 34843.0, "Continent": "Europe", "IndepYear": 1878, "Population": 22455500}, {"GovernmentForm": "Federal Republic", "GNP": 276608.0, "Code": "RUS", "Name": "Russian Federation", "HeadOfState": "Vladimir Putin", "Region": "Eastern Europe", "Capital": 3580, "Code2": "RU", "LifeExpectancy": 67.2, "LocalName": "Rossija", "SurfaceArea": 17075400.0, "GNPOld": 442989.0, "Continent": "Europe", "IndepYear": 1991, "Population": 146934000}, {"GovernmentForm": "Republic", "GNP": 2036.0, "Code": "RWA", "Name": "Rwanda", "HeadOfState": "Paul Kagame", "Region": "Eastern Africa", "Capital": 3047, "Code2": "RW", "LifeExpectancy": 39.3, "LocalName": "Rwanda/Urwanda", "SurfaceArea": 26338.0, "GNPOld": 1863.0, "Continent": "Africa", "IndepYear": 1962, "Population": 7733000}, {"GovernmentForm": "Monarchy", "GNP": 137635.0, "Code": "SAU", "Name": "Saudi Arabia", "HeadOfState": "Fahd ibn Abdul-Aziz al-Sa\\u00b4ud", "Region": "Middle East", "Capital": 3173, "Code2": "SA", "LifeExpectancy": 67.8, "LocalName": "Al-\\u00b4Arabiya as-Sa\\u00b4udiya", "SurfaceArea": 2149690.0, "GNPOld": 146171.0, "Continent": "Asia", "IndepYear": 1932, "Population": 21607000}, {"GovernmentForm": "Islamic Republic", "GNP": 10162.0, "Code": "SDN", "Name": "Sudan", "HeadOfState": "Omar Hassan Ahmad al-Bashir", "Region": "Northern Africa", "Capital": 3225, "Code2": "SD", "LifeExpectancy": 56.6, "LocalName": "As-Sudan", "SurfaceArea": 2505813.0, "GNPOld": null, "Continent": "Africa", "IndepYear": 1956, "Population": 29490000}, {"GovernmentForm": "Republic", "GNP": 4787.0, "Code": "SEN", "Name": "Senegal", "HeadOfState": "Abdoulaye Wade", "Region": "Western Africa", "Capital": 3198, "Code2": "SN", "LifeExpectancy": 62.2, "LocalName": "S\\u00e9n\\u00e9gal/Sounougal", "SurfaceArea": 196722.0, "GNPOld": 4542.0, "Continent": "Africa", "IndepYear": 1960, "Population": 9481000}, {"GovernmentForm": "Republic", "GNP": 86503.0, "Code": "SGP", "Name": "Singapore", "HeadOfState": "Sellapan Rama Nathan", "Region": "Southeast Asia", "Capital": 3208, "Code2": "SG", "LifeExpectancy": 80.1, "LocalName": "Singapore/Singapura/Xinjiapo/Singapur", "SurfaceArea": 618.0, "GNPOld": 96318.0, "Continent": "Asia", "IndepYear": 1965, "Population": 3567000}, {"GovernmentForm": "Dependent Territory of the UK", "GNP": 0.0, "Code": "SGS", "Name": "South Georgia and the South Sandwich Islands", "HeadOfState": "Elisabeth II", "Region": "Antarctica", "Capital": null, "Code2": "GS", "LifeExpectancy": null, "LocalName": "South Georgia and the South Sandwich Islands", "SurfaceArea": 3903.0, "GNPOld": null, "Continent": "Antarctica", "IndepYear": null, "Population": 0}, {"GovernmentForm": "Dependent Territory of the UK", "GNP": 0.0, "Code": "SHN", "Name": "Saint Helena", "HeadOfState": "Elisabeth II", "Region": "Western Africa", "Capital": 3063, "Code2": "SH", "LifeExpectancy": 76.8, "LocalName": "Saint Helena", "SurfaceArea": 314.0, "GNPOld": null, "Continent": "Africa", "IndepYear": null, "Population": 6000}, {"GovernmentForm": "Dependent Territory of Norway", "GNP": 0.0, "Code": "SJM", "Name": "Svalbard and Jan Mayen", "HeadOfState": "Harald V", "Region": "Nordic Countries", "Capital": 938, "Code2": "SJ", "LifeExpectancy": null, "LocalName": "Svalbard og Jan Mayen", "SurfaceArea": 62422.0, "GNPOld": null, "Continent": "Europe", "IndepYear": null, "Population": 3200}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 182.0, "Code": "SLB", "Name": "Solomon Islands", "HeadOfState": "Elisabeth II", "Region": "Melanesia", "Capital": 3161, "Code2": "SB", "LifeExpectancy": 71.3, "LocalName": "Solomon Islands", "SurfaceArea": 28896.0, "GNPOld": 220.0, "Continent": "Oceania", "IndepYear": 1978, "Population": 444000}, {"GovernmentForm": "Republic", "GNP": 746.0, "Code": "SLE", "Name": "Sierra Leone", "HeadOfState": "Ahmed Tejan Kabbah", "Region": "Western Africa", "Capital": 3207, "Code2": "SL", "LifeExpectancy": 45.3, "LocalName": "Sierra Leone", "SurfaceArea": 71740.0, "GNPOld": 858.0, "Continent": "Africa", "IndepYear": 1961, "Population": 4854000}, {"GovernmentForm": "Republic", "GNP": 11863.0, "Code": "SLV", "Name": "El Salvador", "HeadOfState": "Francisco Guillermo Flores P\\u00e9rez", "Region": "Central America", "Capital": 645, "Code2": "SV", "LifeExpectancy": 69.7, "LocalName": "El Salvador", "SurfaceArea": 21041.0, "GNPOld": 11203.0, "Continent": "North America", "IndepYear": 1841, "Population": 6276000}, {"GovernmentForm": "Republic", "GNP": 510.0, "Code": "SMR", "Name": "San Marino", "HeadOfState": null, "Region": "Southern Europe", "Capital": 3171, "Code2": "SM", "LifeExpectancy": 81.1, "LocalName": "San Marino", "SurfaceArea": 61.0, "GNPOld": null, "Continent": "Europe", "IndepYear": 885, "Population": 27000}, {"GovernmentForm": "Republic", "GNP": 935.0, "Code": "SOM", "Name": "Somalia", "HeadOfState": "Abdiqassim Salad Hassan", "Region": "Eastern Africa", "Capital": 3214, "Code2": "SO", "LifeExpectancy": 46.2, "LocalName": "Soomaaliya", "SurfaceArea": 637657.0, "GNPOld": null, "Continent": "Africa", "IndepYear": 1960, "Population": 10097000}, {"GovernmentForm": "Territorial Collectivity of France", "GNP": 0.0, "Code": "SPM", "Name": "Saint Pierre and Miquelon", "HeadOfState": "Jacques Chirac", "Region": "North America", "Capital": 3067, "Code2": "PM", "LifeExpectancy": 77.6, "LocalName": "Saint-Pierre-et-Miquelon", "SurfaceArea": 242.0, "GNPOld": null, "Continent": "North America", "IndepYear": null, "Population": 7000}, {"GovernmentForm": "Republic", "GNP": 6.0, "Code": "STP", "Name": "Sao Tome and Principe", "HeadOfState": "Miguel Trovoada", "Region": "Central Africa", "Capital": 3172, "Code2": "ST", "LifeExpectancy": 65.3, "LocalName": "S\\u00e3o Tom\\u00e9 e Pr\\u00edncipe", "SurfaceArea": 964.0, "GNPOld": null, "Continent": "Africa", "IndepYear": 1975, "Population": 147000}, {"GovernmentForm": "Republic", "GNP": 870.0, "Code": "SUR", "Name": "Suriname", "HeadOfState": "Ronald Venetiaan", "Region": "South America", "Capital": 3243, "Code2": "SR", "LifeExpectancy": 71.4, "LocalName": "Suriname", "SurfaceArea": 163265.0, "GNPOld": 706.0, "Continent": "South America", "IndepYear": 1975, "Population": 417000}, {"GovernmentForm": "Republic", "GNP": 20594.0, "Code": "SVK", "Name": "Slovakia", "HeadOfState": "Rudolf Schuster", "Region": "Eastern Europe", "Capital": 3209, "Code2": "SK", "LifeExpectancy": 73.7, "LocalName": "Slovensko", "SurfaceArea": 49012.0, "GNPOld": 19452.0, "Continent": "Europe", "IndepYear": 1993, "Population": 5398700}, {"GovernmentForm": "Republic", "GNP": 19756.0, "Code": "SVN", "Name": "Slovenia", "HeadOfState": "Milan Kucan", "Region": "Southern Europe", "Capital": 3212, "Code2": "SI", "LifeExpectancy": 74.9, "LocalName": "Slovenija", "SurfaceArea": 20256.0, "GNPOld": 18202.0, "Continent": "Europe", "IndepYear": 1991, "Population": 1987800}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 226492.0, "Code": "SWE", "Name": "Sweden", "HeadOfState": "Carl XVI Gustaf", "Region": "Nordic Countries", "Capital": 3048, "Code2": "SE", "LifeExpectancy": 79.6, "LocalName": "Sverige", "SurfaceArea": 449964.0, "GNPOld": 227757.0, "Continent": "Europe", "IndepYear": 836, "Population": 8861400}, {"GovernmentForm": "Monarchy", "GNP": 1206.0, "Code": "SWZ", "Name": "Swaziland", "HeadOfState": "Mswati III", "Region": "Southern Africa", "Capital": 3244, "Code2": "SZ", "LifeExpectancy": 40.4, "LocalName": "kaNgwane", "SurfaceArea": 17364.0, "GNPOld": 1312.0, "Continent": "Africa", "IndepYear": 1968, "Population": 1008000}, {"GovernmentForm": "Republic", "GNP": 536.0, "Code": "SYC", "Name": "Seychelles", "HeadOfState": "France-Albert Ren\\u00e9", "Region": "Eastern Africa", "Capital": 3206, "Code2": "SC", "LifeExpectancy": 70.4, "LocalName": "Sesel/Seychelles", "SurfaceArea": 455.0, "GNPOld": 539.0, "Continent": "Africa", "IndepYear": 1976, "Population": 77000}, {"GovernmentForm": "Republic", "GNP": 65984.0, "Code": "SYR", "Name": "Syria", "HeadOfState": "Bashar al-Assad", "Region": "Middle East", "Capital": 3250, "Code2": "SY", "LifeExpectancy": 68.5, "LocalName": "Suriya", "SurfaceArea": 185180.0, "GNPOld": 64926.0, "Continent": "Asia", "IndepYear": 1941, "Population": 16125000}, {"GovernmentForm": "Dependent Territory of the UK", "GNP": 96.0, "Code": "TCA", "Name": "Turks and Caicos Islands", "HeadOfState": "Elisabeth II", "Region": "Caribbean", "Capital": 3423, "Code2": "TC", "LifeExpectancy": 73.3, "LocalName": "The Turks and Caicos Islands", "SurfaceArea": 430.0, "GNPOld": null, "Continent": "North America", "IndepYear": null, "Population": 17000}, {"GovernmentForm": "Republic", "GNP": 1208.0, "Code": "TCD", "Name": "Chad", "HeadOfState": "Idriss D\\u00e9by", "Region": "Central Africa", "Capital": 3337, "Code2": "TD", "LifeExpectancy": 50.5, "LocalName": "Tchad/Tshad", "SurfaceArea": 1284000.0, "GNPOld": 1102.0, "Continent": "Africa", "IndepYear": 1960, "Population": 7651000}, {"GovernmentForm": "Republic", "GNP": 1449.0, "Code": "TGO", "Name": "Togo", "HeadOfState": "Gnassingb\\u00e9 Eyad\\u00e9ma", "Region": "Western Africa", "Capital": 3332, "Code2": "TG", "LifeExpectancy": 54.7, "LocalName": "Togo", "SurfaceArea": 56785.0, "GNPOld": 1400.0, "Continent": "Africa", "IndepYear": 1960, "Population": 4629000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 116416.0, "Code": "THA", "Name": "Thailand", "HeadOfState": "Bhumibol Adulyadej", "Region": "Southeast Asia", "Capital": 3320, "Code2": "TH", "LifeExpectancy": 68.6, "LocalName": "Prathet Thai", "SurfaceArea": 513115.0, "GNPOld": 153907.0, "Continent": "Asia", "IndepYear": 1350, "Population": 61399000}, {"GovernmentForm": "Republic", "GNP": 1990.0, "Code": "TJK", "Name": "Tajikistan", "HeadOfState": "Emomali Rahmonov", "Region": "Southern and Central Asia", "Capital": 3261, "Code2": "TJ", "LifeExpectancy": 64.1, "LocalName": "To\\u00e7ikiston", "SurfaceArea": 143100.0, "GNPOld": 1056.0, "Continent": "Asia", "IndepYear": 1991, "Population": 6188000}, {"GovernmentForm": "Nonmetropolitan Territory of New Zealand", "GNP": 0.0, "Code": "TKL", "Name": "Tokelau", "HeadOfState": "Elisabeth II", "Region": "Polynesia", "Capital": 3333, "Code2": "TK", "LifeExpectancy": null, "LocalName": "Tokelau", "SurfaceArea": 12.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": null, "Population": 2000}, {"GovernmentForm": "Republic", "GNP": 4397.0, "Code": "TKM", "Name": "Turkmenistan", "HeadOfState": "Saparmurad Nijazov", "Region": "Southern and Central Asia", "Capital": 3419, "Code2": "TM", "LifeExpectancy": 60.9, "LocalName": "T\\u00fcrkmenostan", "SurfaceArea": 488100.0, "GNPOld": 2000.0, "Continent": "Asia", "IndepYear": 1991, "Population": 4459000}, {"GovernmentForm": "Administrated by the UN", "GNP": 0.0, "Code": "TMP", "Name": "East Timor", "HeadOfState": "Jos\\u00e9 Alexandre Gusm\\u00e3o", "Region": "Southeast Asia", "Capital": 1522, "Code2": "TP", "LifeExpectancy": 46.0, "LocalName": "Timor Timur", "SurfaceArea": 14874.0, "GNPOld": null, "Continent": "Asia", "IndepYear": null, "Population": 885000}, {"GovernmentForm": "Monarchy", "GNP": 146.0, "Code": "TON", "Name": "Tonga", "HeadOfState": "Taufa'ahau Tupou IV", "Region": "Polynesia", "Capital": 3334, "Code2": "TO", "LifeExpectancy": 67.9, "LocalName": "Tonga", "SurfaceArea": 650.0, "GNPOld": 170.0, "Continent": "Oceania", "IndepYear": 1970, "Population": 99000}, {"GovernmentForm": "Republic", "GNP": 6232.0, "Code": "TTO", "Name": "Trinidad and Tobago", "HeadOfState": "Arthur N. R. Robinson", "Region": "Caribbean", "Capital": 3336, "Code2": "TT", "LifeExpectancy": 68.0, "LocalName": "Trinidad and Tobago", "SurfaceArea": 5130.0, "GNPOld": 5867.0, "Continent": "North America", "IndepYear": 1962, "Population": 1295000}, {"GovernmentForm": "Republic", "GNP": 20026.0, "Code": "TUN", "Name": "Tunisia", "HeadOfState": "Zine al-Abidine Ben Ali", "Region": "Northern Africa", "Capital": 3349, "Code2": "TN", "LifeExpectancy": 73.7, "LocalName": "Tunis/Tunisie", "SurfaceArea": 163610.0, "GNPOld": 18898.0, "Continent": "Africa", "IndepYear": 1956, "Population": 9586000}, {"GovernmentForm": "Republic", "GNP": 210721.0, "Code": "TUR", "Name": "Turkey", "HeadOfState": "Ahmet Necdet Sezer", "Region": "Middle East", "Capital": 3358, "Code2": "TR", "LifeExpectancy": 71.0, "LocalName": "T\\u00fcrkiye", "SurfaceArea": 774815.0, "GNPOld": 189122.0, "Continent": "Asia", "IndepYear": 1923, "Population": 66591000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 6.0, "Code": "TUV", "Name": "Tuvalu", "HeadOfState": "Elisabeth II", "Region": "Polynesia", "Capital": 3424, "Code2": "TV", "LifeExpectancy": 66.3, "LocalName": "Tuvalu", "SurfaceArea": 26.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": 1978, "Population": 12000}, {"GovernmentForm": "Republic", "GNP": 256254.0, "Code": "TWN", "Name": "Taiwan", "HeadOfState": "Chen Shui-bian", "Region": "Eastern Asia", "Capital": 3263, "Code2": "TW", "LifeExpectancy": 76.4, "LocalName": "T\\u2019ai-wan", "SurfaceArea": 36188.0, "GNPOld": 263451.0, "Continent": "Asia", "IndepYear": 1945, "Population": 22256000}, {"GovernmentForm": "Republic", "GNP": 8005.0, "Code": "TZA", "Name": "Tanzania", "HeadOfState": "Benjamin William Mkapa", "Region": "Eastern Africa", "Capital": 3306, "Code2": "TZ", "LifeExpectancy": 52.3, "LocalName": "Tanzania", "SurfaceArea": 883749.0, "GNPOld": 7388.0, "Continent": "Africa", "IndepYear": 1961, "Population": 33517000}, {"GovernmentForm": "Republic", "GNP": 6313.0, "Code": "UGA", "Name": "Uganda", "HeadOfState": "Yoweri Museveni", "Region": "Eastern Africa", "Capital": 3425, "Code2": "UG", "LifeExpectancy": 42.9, "LocalName": "Uganda", "SurfaceArea": 241038.0, "GNPOld": 6887.0, "Continent": "Africa", "IndepYear": 1962, "Population": 21778000}, {"GovernmentForm": "Republic", "GNP": 42168.0, "Code": "UKR", "Name": "Ukraine", "HeadOfState": "Leonid Kut\\u0161ma", "Region": "Eastern Europe", "Capital": 3426, "Code2": "UA", "LifeExpectancy": 66.0, "LocalName": "Ukrajina", "SurfaceArea": 603700.0, "GNPOld": 49677.0, "Continent": "Europe", "IndepYear": 1991, "Population": 50456000}, {"GovernmentForm": "Dependent Territory of the US", "GNP": 0.0, "Code": "UMI", "Name": "United States Minor Outlying Islands", "HeadOfState": "George W. Bush", "Region": "Micronesia/Caribbean", "Capital": null, "Code2": "UM", "LifeExpectancy": null, "LocalName": "United States Minor Outlying Islands", "SurfaceArea": 16.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": null, "Population": 0}, {"GovernmentForm": "Republic", "GNP": 20831.0, "Code": "URY", "Name": "Uruguay", "HeadOfState": "Jorge Batlle Ib\\u00e1\\u00f1ez", "Region": "South America", "Capital": 3492, "Code2": "UY", "LifeExpectancy": 75.2, "LocalName": "Uruguay", "SurfaceArea": 175016.0, "GNPOld": 19967.0, "Continent": "South America", "IndepYear": 1828, "Population": 3337000}, {"GovernmentForm": "Federal Republic", "GNP": 8510700.0, "Code": "USA", "Name": "United States", "HeadOfState": "George W. Bush", "Region": "North America", "Capital": 3813, "Code2": "US", "LifeExpectancy": 77.1, "LocalName": "United States", "SurfaceArea": 9363520.0, "GNPOld": 8110900.0, "Continent": "North America", "IndepYear": 1776, "Population": 278357000}, {"GovernmentForm": "Republic", "GNP": 14194.0, "Code": "UZB", "Name": "Uzbekistan", "HeadOfState": "Islam Karimov", "Region": "Southern and Central Asia", "Capital": 3503, "Code2": "UZ", "LifeExpectancy": 63.7, "LocalName": "Uzbekiston", "SurfaceArea": 447400.0, "GNPOld": 21300.0, "Continent": "Asia", "IndepYear": 1991, "Population": 24318000}, {"GovernmentForm": "Independent Church State", "GNP": 9.0, "Code": "VAT", "Name": "Holy See (Vatican City State)", "HeadOfState": "Johannes Paavali II", "Region": "Southern Europe", "Capital": 3538, "Code2": "VA", "LifeExpectancy": null, "LocalName": "Santa Sede/Citt\\u00e0 del Vaticano", "SurfaceArea": 0.4, "GNPOld": null, "Continent": "Europe", "IndepYear": 1929, "Population": 1000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 285.0, "Code": "VCT", "Name": "Saint Vincent and the Grenadines", "HeadOfState": "Elisabeth II", "Region": "Caribbean", "Capital": 3066, "Code2": "VC", "LifeExpectancy": 72.3, "LocalName": "Saint Vincent and the Grenadines", "SurfaceArea": 388.0, "GNPOld": null, "Continent": "North America", "IndepYear": 1979, "Population": 114000}, {"GovernmentForm": "Federal Republic", "GNP": 95023.0, "Code": "VEN", "Name": "Venezuela", "HeadOfState": "Hugo Ch\\u00e1vez Fr\\u00edas", "Region": "South America", "Capital": 3539, "Code2": "VE", "LifeExpectancy": 73.1, "LocalName": "Venezuela", "SurfaceArea": 912050.0, "GNPOld": 88434.0, "Continent": "South America", "IndepYear": 1811, "Population": 24170000}, {"GovernmentForm": "Dependent Territory of the UK", "GNP": 612.0, "Code": "VGB", "Name": "Virgin Islands, British", "HeadOfState": "Elisabeth II", "Region": "Caribbean", "Capital": 537, "Code2": "VG", "LifeExpectancy": 75.4, "LocalName": "British Virgin Islands", "SurfaceArea": 151.0, "GNPOld": 573.0, "Continent": "North America", "IndepYear": null, "Population": 21000}, {"GovernmentForm": "US Territory", "GNP": 0.0, "Code": "VIR", "Name": "Virgin Islands, U.S.", "HeadOfState": "George W. Bush", "Region": "Caribbean", "Capital": 4067, "Code2": "VI", "LifeExpectancy": 78.1, "LocalName": "Virgin Islands of the United States", "SurfaceArea": 347.0, "GNPOld": null, "Continent": "North America", "IndepYear": null, "Population": 93000}, {"GovernmentForm": "Socialistic Republic", "GNP": 21929.0, "Code": "VNM", "Name": "Vietnam", "HeadOfState": "Tr\\u00e2n Duc Luong", "Region": "Southeast Asia", "Capital": 3770, "Code2": "VN", "LifeExpectancy": 69.3, "LocalName": "Vi\\u00eat Nam", "SurfaceArea": 331689.0, "GNPOld": 22834.0, "Continent": "Asia", "IndepYear": 1945, "Population": 79832000}, {"GovernmentForm": "Republic", "GNP": 261.0, "Code": "VUT", "Name": "Vanuatu", "HeadOfState": "John Bani", "Region": "Melanesia", "Capital": 3537, "Code2": "VU", "LifeExpectancy": 60.6, "LocalName": "Vanuatu", "SurfaceArea": 12189.0, "GNPOld": 246.0, "Continent": "Oceania", "IndepYear": 1980, "Population": 190000}, {"GovernmentForm": "Nonmetropolitan Territory of France", "GNP": 0.0, "Code": "WLF", "Name": "Wallis and Futuna", "HeadOfState": "Jacques Chirac", "Region": "Polynesia", "Capital": 3536, "Code2": "WF", "LifeExpectancy": null, "LocalName": "Wallis-et-Futuna", "SurfaceArea": 200.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": null, "Population": 15000}, {"GovernmentForm": "Parlementary Monarchy", "GNP": 141.0, "Code": "WSM", "Name": "Samoa", "HeadOfState": "Malietoa Tanumafili II", "Region": "Polynesia", "Capital": 3169, "Code2": "WS", "LifeExpectancy": 69.2, "LocalName": "Samoa", "SurfaceArea": 2831.0, "GNPOld": 157.0, "Continent": "Oceania", "IndepYear": 1962, "Population": 180000}, {"GovernmentForm": "Republic", "GNP": 6041.0, "Code": "YEM", "Name": "Yemen", "HeadOfState": "Ali Abdallah Salih", "Region": "Middle East", "Capital": 1780, "Code2": "YE", "LifeExpectancy": 59.8, "LocalName": "Al-Yaman", "SurfaceArea": 527968.0, "GNPOld": 5729.0, "Continent": "Asia", "IndepYear": 1918, "Population": 18112000}, {"GovernmentForm": "Federal Republic", "GNP": 17000.0, "Code": "YUG", "Name": "Yugoslavia", "HeadOfState": "Vojislav Ko\\u0161tunica", "Region": "Southern Europe", "Capital": 1792, "Code2": "YU", "LifeExpectancy": 72.4, "LocalName": "Jugoslavija", "SurfaceArea": 102173.0, "GNPOld": null, "Continent": "Europe", "IndepYear": 1918, "Population": 10640000}, {"GovernmentForm": "Republic", "GNP": 116729.0, "Code": "ZAF", "Name": "South Africa", "HeadOfState": "Thabo Mbeki", "Region": "Southern Africa", "Capital": 716, "Code2": "ZA", "LifeExpectancy": 51.1, "LocalName": "South Africa", "SurfaceArea": 1221037.0, "GNPOld": 129092.0, "Continent": "Africa", "IndepYear": 1910, "Population": 40377000}, {"GovernmentForm": "Republic", "GNP": 3377.0, "Code": "ZMB", "Name": "Zambia", "HeadOfState": "Frederick Chiluba", "Region": "Eastern Africa", "Capital": 3162, "Code2": "ZM", "LifeExpectancy": 37.2, "LocalName": "Zambia", "SurfaceArea": 752618.0, "GNPOld": 3922.0, "Continent": "Africa", "IndepYear": 1964, "Population": 9169000}, {"GovernmentForm": "Republic", "GNP": 5951.0, "Code": "ZWE", "Name": "Zimbabwe", "HeadOfState": "Robert G. Mugabe", "Region": "Eastern Africa", "Capital": 4068, "Code2": "ZW", "LifeExpectancy": 37.8, "LocalName": "Zimbabwe", "SurfaceArea": 390757.0, "GNPOld": 8670.0, "Continent": "Africa", "IndepYear": 1980, "Population": 11669000}], "columns": [{"type": "string", "friendly_name": "Code", "name": "Code"}, {"type": "string", "friendly_name": "Name", "name": "Name"}, {"type": "string", "friendly_name": "Continent", "name": "Continent"}, {"type": "string", "friendly_name": "Region", "name": "Region"}, {"type": "float", "friendly_name": "SurfaceArea", "name": "SurfaceArea"}, {"type": "integer", "friendly_name": "IndepYear", "name": "IndepYear"}, {"type": "integer", "friendly_name": "Population", "name": "Population"}, {"type": "float", "friendly_name": "LifeExpectancy", "name": "LifeExpectancy"}, {"type": "float", "friendly_name": "GNP", "name": "GNP"}, {"type": "float", "friendly_name": "GNPOld", "name": "GNPOld"}, {"type": "string", "friendly_name": "LocalName", "name": "LocalName"}, {"type": "string", "friendly_name": "GovernmentForm", "name": "GovernmentForm"}, {"type": "string", "friendly_name": "HeadOfState", "name": "HeadOfState"}, {"type": "integer", "friendly_name": "Capital", "name": "Capital"}, {"type": "string", "friendly_name": "Code2", "name": "Code2"}]}	0.00943279266357421875	2021-11-03 08:26:04.036144+00
2	1	1	5de66f59170c0b2f3b0ef74db5850627	select * from country order by 1;	{"rows": [{"GovernmentForm": "Nonmetropolitan Territory of The Netherlands", "GNP": 828.0, "Code": "ABW", "Name": "Aruba", "HeadOfState": "Beatrix", "Region": "Caribbean", "Capital": 129, "Code2": "AW", "LifeExpectancy": 78.4, "LocalName": "Aruba", "SurfaceArea": 193.0, "GNPOld": 793.0, "Continent": "North America", "IndepYear": null, "Population": 103000}, {"GovernmentForm": "Islamic Emirate", "GNP": 5976.0, "Code": "AFG", "Name": "Afghanistan", "HeadOfState": "Mohammad Omar", "Region": "Southern and Central Asia", "Capital": 1, "Code2": "AF", "LifeExpectancy": 45.9, "LocalName": "Afganistan/Afqanestan", "SurfaceArea": 652090.0, "GNPOld": null, "Continent": "Asia", "IndepYear": 1919, "Population": 22720000}, {"GovernmentForm": "Republic", "GNP": 6648.0, "Code": "AGO", "Name": "Angola", "HeadOfState": "Jos\\u00e9 Eduardo dos Santos", "Region": "Central Africa", "Capital": 56, "Code2": "AO", "LifeExpectancy": 38.3, "LocalName": "Angola", "SurfaceArea": 1246700.0, "GNPOld": 7984.0, "Continent": "Africa", "IndepYear": 1975, "Population": 12878000}, {"GovernmentForm": "Dependent Territory of the UK", "GNP": 63.2, "Code": "AIA", "Name": "Anguilla", "HeadOfState": "Elisabeth II", "Region": "Caribbean", "Capital": 62, "Code2": "AI", "LifeExpectancy": 76.1, "LocalName": "Anguilla", "SurfaceArea": 96.0, "GNPOld": null, "Continent": "North America", "IndepYear": null, "Population": 8000}, {"GovernmentForm": "Republic", "GNP": 3205.0, "Code": "ALB", "Name": "Albania", "HeadOfState": "Rexhep Mejdani", "Region": "Southern Europe", "Capital": 34, "Code2": "AL", "LifeExpectancy": 71.6, "LocalName": "Shqip\\u00ebria", "SurfaceArea": 28748.0, "GNPOld": 2500.0, "Continent": "Europe", "IndepYear": 1912, "Population": 3401200}, {"GovernmentForm": "Parliamentary Coprincipality", "GNP": 1630.0, "Code": "AND", "Name": "Andorra", "HeadOfState": "", "Region": "Southern Europe", "Capital": 55, "Code2": "AD", "LifeExpectancy": 83.5, "LocalName": "Andorra", "SurfaceArea": 468.0, "GNPOld": null, "Continent": "Europe", "IndepYear": 1278, "Population": 78000}, {"GovernmentForm": "Nonmetropolitan Territory of The Netherlands", "GNP": 1941.0, "Code": "ANT", "Name": "Netherlands Antilles", "HeadOfState": "Beatrix", "Region": "Caribbean", "Capital": 33, "Code2": "AN", "LifeExpectancy": 74.7, "LocalName": "Nederlandse Antillen", "SurfaceArea": 800.0, "GNPOld": null, "Continent": "North America", "IndepYear": null, "Population": 217000}, {"GovernmentForm": "Emirate Federation", "GNP": 37966.0, "Code": "ARE", "Name": "United Arab Emirates", "HeadOfState": "Zayid bin Sultan al-Nahayan", "Region": "Middle East", "Capital": 65, "Code2": "AE", "LifeExpectancy": 74.1, "LocalName": "Al-Imarat al-\\u00b4Arabiya al-Muttahida", "SurfaceArea": 83600.0, "GNPOld": 36846.0, "Continent": "Asia", "IndepYear": 1971, "Population": 2441000}, {"GovernmentForm": "Federal Republic", "GNP": 340238.0, "Code": "ARG", "Name": "Argentina", "HeadOfState": "Fernando de la R\\u00faa", "Region": "South America", "Capital": 69, "Code2": "AR", "LifeExpectancy": 75.1, "LocalName": "Argentina", "SurfaceArea": 2780400.0, "GNPOld": 323310.0, "Continent": "South America", "IndepYear": 1816, "Population": 37032000}, {"GovernmentForm": "Republic", "GNP": 1813.0, "Code": "ARM", "Name": "Armenia", "HeadOfState": "Robert Kot\\u0161arjan", "Region": "Middle East", "Capital": 126, "Code2": "AM", "LifeExpectancy": 66.4, "LocalName": "Hajastan", "SurfaceArea": 29800.0, "GNPOld": 1627.0, "Continent": "Asia", "IndepYear": 1991, "Population": 3520000}, {"GovernmentForm": "US Territory", "GNP": 334.0, "Code": "ASM", "Name": "American Samoa", "HeadOfState": "George W. Bush", "Region": "Polynesia", "Capital": 54, "Code2": "AS", "LifeExpectancy": 75.1, "LocalName": "Amerika Samoa", "SurfaceArea": 199.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": null, "Population": 68000}, {"GovernmentForm": "Co-administrated", "GNP": 0.0, "Code": "ATA", "Name": "Antarctica", "HeadOfState": "", "Region": "Antarctica", "Capital": null, "Code2": "AQ", "LifeExpectancy": null, "LocalName": "\\u2013", "SurfaceArea": 13120000.0, "GNPOld": null, "Continent": "Antarctica", "IndepYear": null, "Population": 0}, {"GovernmentForm": "Nonmetropolitan Territory of France", "GNP": 0.0, "Code": "ATF", "Name": "French Southern territories", "HeadOfState": "Jacques Chirac", "Region": "Antarctica", "Capital": null, "Code2": "TF", "LifeExpectancy": null, "LocalName": "Terres australes fran\\u00e7aises", "SurfaceArea": 7780.0, "GNPOld": null, "Continent": "Antarctica", "IndepYear": null, "Population": 0}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 612.0, "Code": "ATG", "Name": "Antigua and Barbuda", "HeadOfState": "Elisabeth II", "Region": "Caribbean", "Capital": 63, "Code2": "AG", "LifeExpectancy": 70.5, "LocalName": "Antigua and Barbuda", "SurfaceArea": 442.0, "GNPOld": 584.0, "Continent": "North America", "IndepYear": 1981, "Population": 68000}, {"GovernmentForm": "Constitutional Monarchy, Federation", "GNP": 351182.0, "Code": "AUS", "Name": "Australia", "HeadOfState": "Elisabeth II", "Region": "Australia and New Zealand", "Capital": 135, "Code2": "AU", "LifeExpectancy": 79.8, "LocalName": "Australia", "SurfaceArea": 7741220.0, "GNPOld": 392911.0, "Continent": "Oceania", "IndepYear": 1901, "Population": 18886000}, {"GovernmentForm": "Federal Republic", "GNP": 211860.0, "Code": "AUT", "Name": "Austria", "HeadOfState": "Thomas Klestil", "Region": "Western Europe", "Capital": 1523, "Code2": "AT", "LifeExpectancy": 77.7, "LocalName": "\\u00d6sterreich", "SurfaceArea": 83859.0, "GNPOld": 206025.0, "Continent": "Europe", "IndepYear": 1918, "Population": 8091800}, {"GovernmentForm": "Federal Republic", "GNP": 4127.0, "Code": "AZE", "Name": "Azerbaijan", "HeadOfState": "Heyd\\u00e4r \\u00c4liyev", "Region": "Middle East", "Capital": 144, "Code2": "AZ", "LifeExpectancy": 62.9, "LocalName": "Az\\u00e4rbaycan", "SurfaceArea": 86600.0, "GNPOld": 4100.0, "Continent": "Asia", "IndepYear": 1991, "Population": 7734000}, {"GovernmentForm": "Republic", "GNP": 903.0, "Code": "BDI", "Name": "Burundi", "HeadOfState": "Pierre Buyoya", "Region": "Eastern Africa", "Capital": 552, "Code2": "BI", "LifeExpectancy": 46.2, "LocalName": "Burundi/Uburundi", "SurfaceArea": 27834.0, "GNPOld": 982.0, "Continent": "Africa", "IndepYear": 1962, "Population": 6695000}, {"GovernmentForm": "Constitutional Monarchy, Federation", "GNP": 249704.0, "Code": "BEL", "Name": "Belgium", "HeadOfState": "Albert II", "Region": "Western Europe", "Capital": 179, "Code2": "BE", "LifeExpectancy": 77.8, "LocalName": "Belgi\\u00eb/Belgique", "SurfaceArea": 30518.0, "GNPOld": 243948.0, "Continent": "Europe", "IndepYear": 1830, "Population": 10239000}, {"GovernmentForm": "Republic", "GNP": 2357.0, "Code": "BEN", "Name": "Benin", "HeadOfState": "Mathieu K\\u00e9r\\u00e9kou", "Region": "Western Africa", "Capital": 187, "Code2": "BJ", "LifeExpectancy": 50.2, "LocalName": "B\\u00e9nin", "SurfaceArea": 112622.0, "GNPOld": 2141.0, "Continent": "Africa", "IndepYear": 1960, "Population": 6097000}, {"GovernmentForm": "Republic", "GNP": 2425.0, "Code": "BFA", "Name": "Burkina Faso", "HeadOfState": "Blaise Compaor\\u00e9", "Region": "Western Africa", "Capital": 549, "Code2": "BF", "LifeExpectancy": 46.7, "LocalName": "Burkina Faso", "SurfaceArea": 274000.0, "GNPOld": 2201.0, "Continent": "Africa", "IndepYear": 1960, "Population": 11937000}, {"GovernmentForm": "Republic", "GNP": 32852.0, "Code": "BGD", "Name": "Bangladesh", "HeadOfState": "Shahabuddin Ahmad", "Region": "Southern and Central Asia", "Capital": 150, "Code2": "BD", "LifeExpectancy": 60.2, "LocalName": "Bangladesh", "SurfaceArea": 143998.0, "GNPOld": 31966.0, "Continent": "Asia", "IndepYear": 1971, "Population": 129155000}, {"GovernmentForm": "Republic", "GNP": 12178.0, "Code": "BGR", "Name": "Bulgaria", "HeadOfState": "Petar Stojanov", "Region": "Eastern Europe", "Capital": 539, "Code2": "BG", "LifeExpectancy": 70.9, "LocalName": "Balgarija", "SurfaceArea": 110994.0, "GNPOld": 10169.0, "Continent": "Europe", "IndepYear": 1908, "Population": 8190900}, {"GovernmentForm": "Monarchy (Emirate)", "GNP": 6366.0, "Code": "BHR", "Name": "Bahrain", "HeadOfState": "Hamad ibn Isa al-Khalifa", "Region": "Middle East", "Capital": 149, "Code2": "BH", "LifeExpectancy": 73.0, "LocalName": "Al-Bahrayn", "SurfaceArea": 694.0, "GNPOld": 6097.0, "Continent": "Asia", "IndepYear": 1971, "Population": 617000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 3527.0, "Code": "BHS", "Name": "Bahamas", "HeadOfState": "Elisabeth II", "Region": "Caribbean", "Capital": 148, "Code2": "BS", "LifeExpectancy": 71.1, "LocalName": "The Bahamas", "SurfaceArea": 13878.0, "GNPOld": 3347.0, "Continent": "North America", "IndepYear": 1973, "Population": 307000}, {"GovernmentForm": "Federal Republic", "GNP": 2841.0, "Code": "BIH", "Name": "Bosnia and Herzegovina", "HeadOfState": "Ante Jelavic", "Region": "Southern Europe", "Capital": 201, "Code2": "BA", "LifeExpectancy": 71.5, "LocalName": "Bosna i Hercegovina", "SurfaceArea": 51197.0, "GNPOld": null, "Continent": "Europe", "IndepYear": 1992, "Population": 3972000}, {"GovernmentForm": "Republic", "GNP": 13714.0, "Code": "BLR", "Name": "Belarus", "HeadOfState": "Aljaksandr Luka\\u0161enka", "Region": "Eastern Europe", "Capital": 3520, "Code2": "BY", "LifeExpectancy": 68.0, "LocalName": "Belarus", "SurfaceArea": 207600.0, "GNPOld": null, "Continent": "Europe", "IndepYear": 1991, "Population": 10236000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 630.0, "Code": "BLZ", "Name": "Belize", "HeadOfState": "Elisabeth II", "Region": "Central America", "Capital": 185, "Code2": "BZ", "LifeExpectancy": 70.9, "LocalName": "Belize", "SurfaceArea": 22696.0, "GNPOld": 616.0, "Continent": "North America", "IndepYear": 1981, "Population": 241000}, {"GovernmentForm": "Dependent Territory of the UK", "GNP": 2328.0, "Code": "BMU", "Name": "Bermuda", "HeadOfState": "Elisabeth II", "Region": "North America", "Capital": 191, "Code2": "BM", "LifeExpectancy": 76.9, "LocalName": "Bermuda", "SurfaceArea": 53.0, "GNPOld": 2190.0, "Continent": "North America", "IndepYear": null, "Population": 65000}, {"GovernmentForm": "Republic", "GNP": 8571.0, "Code": "BOL", "Name": "Bolivia", "HeadOfState": "Hugo B\\u00e1nzer Su\\u00e1rez", "Region": "South America", "Capital": 194, "Code2": "BO", "LifeExpectancy": 63.7, "LocalName": "Bolivia", "SurfaceArea": 1098581.0, "GNPOld": 7967.0, "Continent": "South America", "IndepYear": 1825, "Population": 8329000}, {"GovernmentForm": "Federal Republic", "GNP": 776739.0, "Code": "BRA", "Name": "Brazil", "HeadOfState": "Fernando Henrique Cardoso", "Region": "South America", "Capital": 211, "Code2": "BR", "LifeExpectancy": 62.9, "LocalName": "Brasil", "SurfaceArea": 8547403.0, "GNPOld": 804108.0, "Continent": "South America", "IndepYear": 1822, "Population": 170115000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 2223.0, "Code": "BRB", "Name": "Barbados", "HeadOfState": "Elisabeth II", "Region": "Caribbean", "Capital": 174, "Code2": "BB", "LifeExpectancy": 73.0, "LocalName": "Barbados", "SurfaceArea": 430.0, "GNPOld": 2186.0, "Continent": "North America", "IndepYear": 1966, "Population": 270000}, {"GovernmentForm": "Monarchy (Sultanate)", "GNP": 11705.0, "Code": "BRN", "Name": "Brunei", "HeadOfState": "Haji Hassan al-Bolkiah", "Region": "Southeast Asia", "Capital": 538, "Code2": "BN", "LifeExpectancy": 73.6, "LocalName": "Brunei Darussalam", "SurfaceArea": 5765.0, "GNPOld": 12460.0, "Continent": "Asia", "IndepYear": 1984, "Population": 328000}, {"GovernmentForm": "Monarchy", "GNP": 372.0, "Code": "BTN", "Name": "Bhutan", "HeadOfState": "Jigme Singye Wangchuk", "Region": "Southern and Central Asia", "Capital": 192, "Code2": "BT", "LifeExpectancy": 52.4, "LocalName": "Druk-Yul", "SurfaceArea": 47000.0, "GNPOld": 383.0, "Continent": "Asia", "IndepYear": 1910, "Population": 2124000}, {"GovernmentForm": "Dependent Territory of Norway", "GNP": 0.0, "Code": "BVT", "Name": "Bouvet Island", "HeadOfState": "Harald V", "Region": "Antarctica", "Capital": null, "Code2": "BV", "LifeExpectancy": null, "LocalName": "Bouvet\\u00f8ya", "SurfaceArea": 59.0, "GNPOld": null, "Continent": "Antarctica", "IndepYear": null, "Population": 0}, {"GovernmentForm": "Republic", "GNP": 4834.0, "Code": "BWA", "Name": "Botswana", "HeadOfState": "Festus G. Mogae", "Region": "Southern Africa", "Capital": 204, "Code2": "BW", "LifeExpectancy": 39.3, "LocalName": "Botswana", "SurfaceArea": 581730.0, "GNPOld": 4935.0, "Continent": "Africa", "IndepYear": 1966, "Population": 1622000}, {"GovernmentForm": "Republic", "GNP": 1054.0, "Code": "CAF", "Name": "Central African Republic", "HeadOfState": "Ange-F\\u00e9lix Patass\\u00e9", "Region": "Central Africa", "Capital": 1889, "Code2": "CF", "LifeExpectancy": 44.0, "LocalName": "Centrafrique/B\\u00ea-Afr\\u00eeka", "SurfaceArea": 622984.0, "GNPOld": 993.0, "Continent": "Africa", "IndepYear": 1960, "Population": 3615000}, {"GovernmentForm": "Constitutional Monarchy, Federation", "GNP": 598862.0, "Code": "CAN", "Name": "Canada", "HeadOfState": "Elisabeth II", "Region": "North America", "Capital": 1822, "Code2": "CA", "LifeExpectancy": 79.4, "LocalName": "Canada", "SurfaceArea": 9970610.0, "GNPOld": 625626.0, "Continent": "North America", "IndepYear": 1867, "Population": 31147000}, {"GovernmentForm": "Territory of Australia", "GNP": 0.0, "Code": "CCK", "Name": "Cocos (Keeling) Islands", "HeadOfState": "Elisabeth II", "Region": "Australia and New Zealand", "Capital": 2317, "Code2": "CC", "LifeExpectancy": null, "LocalName": "Cocos (Keeling) Islands", "SurfaceArea": 14.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": null, "Population": 600}, {"GovernmentForm": "Federation", "GNP": 264478.0, "Code": "CHE", "Name": "Switzerland", "HeadOfState": "Adolf Ogi", "Region": "Western Europe", "Capital": 3248, "Code2": "CH", "LifeExpectancy": 79.6, "LocalName": "Schweiz/Suisse/Svizzera/Svizra", "SurfaceArea": 41284.0, "GNPOld": 256092.0, "Continent": "Europe", "IndepYear": 1499, "Population": 7160400}, {"GovernmentForm": "Republic", "GNP": 72949.0, "Code": "CHL", "Name": "Chile", "HeadOfState": "Ricardo Lagos Escobar", "Region": "South America", "Capital": 554, "Code2": "CL", "LifeExpectancy": 75.7, "LocalName": "Chile", "SurfaceArea": 756626.0, "GNPOld": 75780.0, "Continent": "South America", "IndepYear": 1810, "Population": 15211000}, {"GovernmentForm": "People'sRepublic", "GNP": 982268.0, "Code": "CHN", "Name": "China", "HeadOfState": "Jiang Zemin", "Region": "Eastern Asia", "Capital": 1891, "Code2": "CN", "LifeExpectancy": 71.4, "LocalName": "Zhongquo", "SurfaceArea": 9572900.0, "GNPOld": 917719.0, "Continent": "Asia", "IndepYear": -1523, "Population": 1277558000}, {"GovernmentForm": "Republic", "GNP": 11345.0, "Code": "CIV", "Name": "C\\u00f4te d\\u2019Ivoire", "HeadOfState": "Laurent Gbagbo", "Region": "Western Africa", "Capital": 2814, "Code2": "CI", "LifeExpectancy": 45.2, "LocalName": "C\\u00f4te d\\u2019Ivoire", "SurfaceArea": 322463.0, "GNPOld": 10285.0, "Continent": "Africa", "IndepYear": 1960, "Population": 14786000}, {"GovernmentForm": "Republic", "GNP": 9174.0, "Code": "CMR", "Name": "Cameroon", "HeadOfState": "Paul Biya", "Region": "Central Africa", "Capital": 1804, "Code2": "CM", "LifeExpectancy": 54.8, "LocalName": "Cameroun/Cameroon", "SurfaceArea": 475442.0, "GNPOld": 8596.0, "Continent": "Africa", "IndepYear": 1960, "Population": 15085000}, {"GovernmentForm": "Republic", "GNP": 6964.0, "Code": "COD", "Name": "Congo, The Democratic Republic of the", "HeadOfState": "Joseph Kabila", "Region": "Central Africa", "Capital": 2298, "Code2": "CD", "LifeExpectancy": 48.8, "LocalName": "R\\u00e9publique D\\u00e9mocratique du Congo", "SurfaceArea": 2344858.0, "GNPOld": 2474.0, "Continent": "Africa", "IndepYear": 1960, "Population": 51654000}, {"GovernmentForm": "Republic", "GNP": 2108.0, "Code": "COG", "Name": "Congo", "HeadOfState": "Denis Sassou-Nguesso", "Region": "Central Africa", "Capital": 2296, "Code2": "CG", "LifeExpectancy": 47.4, "LocalName": "Congo", "SurfaceArea": 342000.0, "GNPOld": 2287.0, "Continent": "Africa", "IndepYear": 1960, "Population": 2943000}, {"GovernmentForm": "Nonmetropolitan Territory of New Zealand", "GNP": 100.0, "Code": "COK", "Name": "Cook Islands", "HeadOfState": "Elisabeth II", "Region": "Polynesia", "Capital": 583, "Code2": "CK", "LifeExpectancy": 71.1, "LocalName": "The Cook Islands", "SurfaceArea": 236.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": null, "Population": 20000}, {"GovernmentForm": "Republic", "GNP": 102896.0, "Code": "COL", "Name": "Colombia", "HeadOfState": "Andr\\u00e9s Pastrana Arango", "Region": "South America", "Capital": 2257, "Code2": "CO", "LifeExpectancy": 70.3, "LocalName": "Colombia", "SurfaceArea": 1138914.0, "GNPOld": 105116.0, "Continent": "South America", "IndepYear": 1810, "Population": 42321000}, {"GovernmentForm": "Republic", "GNP": 4401.0, "Code": "COM", "Name": "Comoros", "HeadOfState": "Azali Assoumani", "Region": "Eastern Africa", "Capital": 2295, "Code2": "KM", "LifeExpectancy": 60.0, "LocalName": "Komori/Comores", "SurfaceArea": 1862.0, "GNPOld": 4361.0, "Continent": "Africa", "IndepYear": 1975, "Population": 578000}, {"GovernmentForm": "Republic", "GNP": 435.0, "Code": "CPV", "Name": "Cape Verde", "HeadOfState": "Ant\\u00f3nio Mascarenhas Monteiro", "Region": "Western Africa", "Capital": 1859, "Code2": "CV", "LifeExpectancy": 68.9, "LocalName": "Cabo Verde", "SurfaceArea": 4033.0, "GNPOld": 420.0, "Continent": "Africa", "IndepYear": 1975, "Population": 428000}, {"GovernmentForm": "Republic", "GNP": 10226.0, "Code": "CRI", "Name": "Costa Rica", "HeadOfState": "Miguel \\u00c1ngel Rodr\\u00edguez Echeverr\\u00eda", "Region": "Central America", "Capital": 584, "Code2": "CR", "LifeExpectancy": 75.8, "LocalName": "Costa Rica", "SurfaceArea": 51100.0, "GNPOld": 9757.0, "Continent": "North America", "IndepYear": 1821, "Population": 4023000}, {"GovernmentForm": "Socialistic Republic", "GNP": 17843.0, "Code": "CUB", "Name": "Cuba", "HeadOfState": "Fidel Castro Ruz", "Region": "Caribbean", "Capital": 2413, "Code2": "CU", "LifeExpectancy": 76.2, "LocalName": "Cuba", "SurfaceArea": 110861.0, "GNPOld": 18862.0, "Continent": "North America", "IndepYear": 1902, "Population": 11201000}, {"GovernmentForm": "Territory of Australia", "GNP": 0.0, "Code": "CXR", "Name": "Christmas Island", "HeadOfState": "Elisabeth II", "Region": "Australia and New Zealand", "Capital": 1791, "Code2": "CX", "LifeExpectancy": null, "LocalName": "Christmas Island", "SurfaceArea": 135.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": null, "Population": 2500}, {"GovernmentForm": "Dependent Territory of the UK", "GNP": 1263.0, "Code": "CYM", "Name": "Cayman Islands", "HeadOfState": "Elisabeth II", "Region": "Caribbean", "Capital": 553, "Code2": "KY", "LifeExpectancy": 78.9, "LocalName": "Cayman Islands", "SurfaceArea": 264.0, "GNPOld": 1186.0, "Continent": "North America", "IndepYear": null, "Population": 38000}, {"GovernmentForm": "Republic", "GNP": 9333.0, "Code": "CYP", "Name": "Cyprus", "HeadOfState": "Glafkos Klerides", "Region": "Middle East", "Capital": 2430, "Code2": "CY", "LifeExpectancy": 76.7, "LocalName": "K\\u00fdpros/Kibris", "SurfaceArea": 9251.0, "GNPOld": 8246.0, "Continent": "Asia", "IndepYear": 1960, "Population": 754700}, {"GovernmentForm": "Republic", "GNP": 55017.0, "Code": "CZE", "Name": "Czech Republic", "HeadOfState": "V\\u00e1clav Havel", "Region": "Eastern Europe", "Capital": 3339, "Code2": "CZ", "LifeExpectancy": 74.5, "LocalName": "\\u00b8esko", "SurfaceArea": 78866.0, "GNPOld": 52037.0, "Continent": "Europe", "IndepYear": 1993, "Population": 10278100}, {"GovernmentForm": "Federal Republic", "GNP": 2133367.0, "Code": "DEU", "Name": "Germany", "HeadOfState": "Johannes Rau", "Region": "Western Europe", "Capital": 3068, "Code2": "DE", "LifeExpectancy": 77.4, "LocalName": "Deutschland", "SurfaceArea": 357022.0, "GNPOld": 2102826.0, "Continent": "Europe", "IndepYear": 1955, "Population": 82164700}, {"GovernmentForm": "Republic", "GNP": 382.0, "Code": "DJI", "Name": "Djibouti", "HeadOfState": "Ismail Omar Guelleh", "Region": "Eastern Africa", "Capital": 585, "Code2": "DJ", "LifeExpectancy": 50.8, "LocalName": "Djibouti/Jibuti", "SurfaceArea": 23200.0, "GNPOld": 373.0, "Continent": "Africa", "IndepYear": 1977, "Population": 638000}, {"GovernmentForm": "Republic", "GNP": 256.0, "Code": "DMA", "Name": "Dominica", "HeadOfState": "Vernon Shaw", "Region": "Caribbean", "Capital": 586, "Code2": "DM", "LifeExpectancy": 73.4, "LocalName": "Dominica", "SurfaceArea": 751.0, "GNPOld": 243.0, "Continent": "North America", "IndepYear": 1978, "Population": 71000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 174099.0, "Code": "DNK", "Name": "Denmark", "HeadOfState": "Margrethe II", "Region": "Nordic Countries", "Capital": 3315, "Code2": "DK", "LifeExpectancy": 76.5, "LocalName": "Danmark", "SurfaceArea": 43094.0, "GNPOld": 169264.0, "Continent": "Europe", "IndepYear": 800, "Population": 5330000}, {"GovernmentForm": "Republic", "GNP": 15846.0, "Code": "DOM", "Name": "Dominican Republic", "HeadOfState": "Hip\\u00f3lito Mej\\u00eda Dom\\u00ednguez", "Region": "Caribbean", "Capital": 587, "Code2": "DO", "LifeExpectancy": 73.2, "LocalName": "Rep\\u00fablica Dominicana", "SurfaceArea": 48511.0, "GNPOld": 15076.0, "Continent": "North America", "IndepYear": 1844, "Population": 8495000}, {"GovernmentForm": "Republic", "GNP": 49982.0, "Code": "DZA", "Name": "Algeria", "HeadOfState": "Abdelaziz Bouteflika", "Region": "Northern Africa", "Capital": 35, "Code2": "DZ", "LifeExpectancy": 69.7, "LocalName": "Al-Jaza\\u2019ir/Alg\\u00e9rie", "SurfaceArea": 2381741.0, "GNPOld": 46966.0, "Continent": "Africa", "IndepYear": 1962, "Population": 31471000}, {"GovernmentForm": "Republic", "GNP": 19770.0, "Code": "ECU", "Name": "Ecuador", "HeadOfState": "Gustavo Noboa Bejarano", "Region": "South America", "Capital": 594, "Code2": "EC", "LifeExpectancy": 71.1, "LocalName": "Ecuador", "SurfaceArea": 283561.0, "GNPOld": 19769.0, "Continent": "South America", "IndepYear": 1822, "Population": 12646000}, {"GovernmentForm": "Republic", "GNP": 82710.0, "Code": "EGY", "Name": "Egypt", "HeadOfState": "Hosni Mubarak", "Region": "Northern Africa", "Capital": 608, "Code2": "EG", "LifeExpectancy": 63.3, "LocalName": "Misr", "SurfaceArea": 1001449.0, "GNPOld": 75617.0, "Continent": "Africa", "IndepYear": 1922, "Population": 68470000}, {"GovernmentForm": "Republic", "GNP": 650.0, "Code": "ERI", "Name": "Eritrea", "HeadOfState": "Isayas Afewerki [Isaias Afwerki]", "Region": "Eastern Africa", "Capital": 652, "Code2": "ER", "LifeExpectancy": 55.8, "LocalName": "Ertra", "SurfaceArea": 117600.0, "GNPOld": 755.0, "Continent": "Africa", "IndepYear": 1993, "Population": 3850000}, {"GovernmentForm": "Occupied by Marocco", "GNP": 60.0, "Code": "ESH", "Name": "Western Sahara", "HeadOfState": "Mohammed Abdel Aziz", "Region": "Northern Africa", "Capital": 2453, "Code2": "EH", "LifeExpectancy": 49.8, "LocalName": "As-Sahrawiya", "SurfaceArea": 266000.0, "GNPOld": null, "Continent": "Africa", "IndepYear": null, "Population": 293000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 553233.0, "Code": "ESP", "Name": "Spain", "HeadOfState": "Juan Carlos I", "Region": "Southern Europe", "Capital": 653, "Code2": "ES", "LifeExpectancy": 78.8, "LocalName": "Espa\\u00f1a", "SurfaceArea": 505992.0, "GNPOld": 532031.0, "Continent": "Europe", "IndepYear": 1492, "Population": 39441700}, {"GovernmentForm": "Republic", "GNP": 5328.0, "Code": "EST", "Name": "Estonia", "HeadOfState": "Lennart Meri", "Region": "Baltic Countries", "Capital": 3791, "Code2": "EE", "LifeExpectancy": 69.5, "LocalName": "Eesti", "SurfaceArea": 45227.0, "GNPOld": 3371.0, "Continent": "Europe", "IndepYear": 1991, "Population": 1439200}, {"GovernmentForm": "Republic", "GNP": 6353.0, "Code": "ETH", "Name": "Ethiopia", "HeadOfState": "Negasso Gidada", "Region": "Eastern Africa", "Capital": 756, "Code2": "ET", "LifeExpectancy": 45.2, "LocalName": "YeItyop\\u00b4iya", "SurfaceArea": 1104300.0, "GNPOld": 6180.0, "Continent": "Africa", "IndepYear": -1000, "Population": 62565000}, {"GovernmentForm": "Republic", "GNP": 121914.0, "Code": "FIN", "Name": "Finland", "HeadOfState": "Tarja Halonen", "Region": "Nordic Countries", "Capital": 3236, "Code2": "FI", "LifeExpectancy": 77.4, "LocalName": "Suomi", "SurfaceArea": 338145.0, "GNPOld": 119833.0, "Continent": "Europe", "IndepYear": 1917, "Population": 5171300}, {"GovernmentForm": "Republic", "GNP": 1536.0, "Code": "FJI", "Name": "Fiji Islands", "HeadOfState": "Josefa Iloilo", "Region": "Melanesia", "Capital": 764, "Code2": "FJ", "LifeExpectancy": 67.9, "LocalName": "Fiji Islands", "SurfaceArea": 18274.0, "GNPOld": 2149.0, "Continent": "Oceania", "IndepYear": 1970, "Population": 817000}, {"GovernmentForm": "Dependent Territory of the UK", "GNP": 0.0, "Code": "FLK", "Name": "Falkland Islands", "HeadOfState": "Elisabeth II", "Region": "South America", "Capital": 763, "Code2": "FK", "LifeExpectancy": null, "LocalName": "Falkland Islands", "SurfaceArea": 12173.0, "GNPOld": null, "Continent": "South America", "IndepYear": null, "Population": 2000}, {"GovernmentForm": "Republic", "GNP": 1424285.0, "Code": "FRA", "Name": "France", "HeadOfState": "Jacques Chirac", "Region": "Western Europe", "Capital": 2974, "Code2": "FR", "LifeExpectancy": 78.8, "LocalName": "France", "SurfaceArea": 551500.0, "GNPOld": 1392448.0, "Continent": "Europe", "IndepYear": 843, "Population": 59225700}, {"GovernmentForm": "Part of Denmark", "GNP": 0.0, "Code": "FRO", "Name": "Faroe Islands", "HeadOfState": "Margrethe II", "Region": "Nordic Countries", "Capital": 901, "Code2": "FO", "LifeExpectancy": 78.4, "LocalName": "F\\u00f8royar", "SurfaceArea": 1399.0, "GNPOld": null, "Continent": "Europe", "IndepYear": null, "Population": 43000}, {"GovernmentForm": "Federal Republic", "GNP": 212.0, "Code": "FSM", "Name": "Micronesia, Federated States of", "HeadOfState": "Leo A. Falcam", "Region": "Micronesia", "Capital": 2689, "Code2": "FM", "LifeExpectancy": 68.6, "LocalName": "Micronesia", "SurfaceArea": 702.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": 1990, "Population": 119000}, {"GovernmentForm": "Republic", "GNP": 5493.0, "Code": "GAB", "Name": "Gabon", "HeadOfState": "Omar Bongo", "Region": "Central Africa", "Capital": 902, "Code2": "GA", "LifeExpectancy": 50.1, "LocalName": "Le Gabon", "SurfaceArea": 267668.0, "GNPOld": 5279.0, "Continent": "Africa", "IndepYear": 1960, "Population": 1226000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 1378330.0, "Code": "GBR", "Name": "United Kingdom", "HeadOfState": "Elisabeth II", "Region": "British Islands", "Capital": 456, "Code2": "GB", "LifeExpectancy": 77.7, "LocalName": "United Kingdom", "SurfaceArea": 242900.0, "GNPOld": 1296830.0, "Continent": "Europe", "IndepYear": 1066, "Population": 59623400}, {"GovernmentForm": "Republic", "GNP": 6064.0, "Code": "GEO", "Name": "Georgia", "HeadOfState": "Eduard \\u0160evardnadze", "Region": "Middle East", "Capital": 905, "Code2": "GE", "LifeExpectancy": 64.5, "LocalName": "Sakartvelo", "SurfaceArea": 69700.0, "GNPOld": 5924.0, "Continent": "Asia", "IndepYear": 1991, "Population": 4968000}, {"GovernmentForm": "Republic", "GNP": 7137.0, "Code": "GHA", "Name": "Ghana", "HeadOfState": "John Kufuor", "Region": "Western Africa", "Capital": 910, "Code2": "GH", "LifeExpectancy": 57.4, "LocalName": "Ghana", "SurfaceArea": 238533.0, "GNPOld": 6884.0, "Continent": "Africa", "IndepYear": 1957, "Population": 20212000}, {"GovernmentForm": "Dependent Territory of the UK", "GNP": 258.0, "Code": "GIB", "Name": "Gibraltar", "HeadOfState": "Elisabeth II", "Region": "Southern Europe", "Capital": 915, "Code2": "GI", "LifeExpectancy": 79.0, "LocalName": "Gibraltar", "SurfaceArea": 6.0, "GNPOld": null, "Continent": "Europe", "IndepYear": null, "Population": 25000}, {"GovernmentForm": "Republic", "GNP": 2352.0, "Code": "GIN", "Name": "Guinea", "HeadOfState": "Lansana Cont\\u00e9", "Region": "Western Africa", "Capital": 926, "Code2": "GN", "LifeExpectancy": 45.6, "LocalName": "Guin\\u00e9e", "SurfaceArea": 245857.0, "GNPOld": 2383.0, "Continent": "Africa", "IndepYear": 1958, "Population": 7430000}, {"GovernmentForm": "Overseas Department of France", "GNP": 3501.0, "Code": "GLP", "Name": "Guadeloupe", "HeadOfState": "Jacques Chirac", "Region": "Caribbean", "Capital": 919, "Code2": "GP", "LifeExpectancy": 77.0, "LocalName": "Guadeloupe", "SurfaceArea": 1705.0, "GNPOld": null, "Continent": "North America", "IndepYear": null, "Population": 456000}, {"GovernmentForm": "Republic", "GNP": 320.0, "Code": "GMB", "Name": "Gambia", "HeadOfState": "Yahya Jammeh", "Region": "Western Africa", "Capital": 904, "Code2": "GM", "LifeExpectancy": 53.2, "LocalName": "The Gambia", "SurfaceArea": 11295.0, "GNPOld": 325.0, "Continent": "Africa", "IndepYear": 1965, "Population": 1305000}, {"GovernmentForm": "Republic", "GNP": 293.0, "Code": "GNB", "Name": "Guinea-Bissau", "HeadOfState": "Kumba Ial\\u00e1", "Region": "Western Africa", "Capital": 927, "Code2": "GW", "LifeExpectancy": 49.0, "LocalName": "Guin\\u00e9-Bissau", "SurfaceArea": 36125.0, "GNPOld": 272.0, "Continent": "Africa", "IndepYear": 1974, "Population": 1213000}, {"GovernmentForm": "Republic", "GNP": 283.0, "Code": "GNQ", "Name": "Equatorial Guinea", "HeadOfState": "Teodoro Obiang Nguema Mbasogo", "Region": "Central Africa", "Capital": 2972, "Code2": "GQ", "LifeExpectancy": 53.6, "LocalName": "Guinea Ecuatorial", "SurfaceArea": 28051.0, "GNPOld": 542.0, "Continent": "Africa", "IndepYear": 1968, "Population": 453000}, {"GovernmentForm": "Republic", "GNP": 120724.0, "Code": "GRC", "Name": "Greece", "HeadOfState": "Kostis Stefanopoulos", "Region": "Southern Europe", "Capital": 2401, "Code2": "GR", "LifeExpectancy": 78.4, "LocalName": "Ell\\u00e1da", "SurfaceArea": 131626.0, "GNPOld": 119946.0, "Continent": "Europe", "IndepYear": 1830, "Population": 10545700}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 318.0, "Code": "GRD", "Name": "Grenada", "HeadOfState": "Elisabeth II", "Region": "Caribbean", "Capital": 916, "Code2": "GD", "LifeExpectancy": 64.5, "LocalName": "Grenada", "SurfaceArea": 344.0, "GNPOld": null, "Continent": "North America", "IndepYear": 1974, "Population": 94000}, {"GovernmentForm": "Part of Denmark", "GNP": 0.0, "Code": "GRL", "Name": "Greenland", "HeadOfState": "Margrethe II", "Region": "North America", "Capital": 917, "Code2": "GL", "LifeExpectancy": 68.1, "LocalName": "Kalaallit Nunaat/Gr\\u00f8nland", "SurfaceArea": 2166090.0, "GNPOld": null, "Continent": "North America", "IndepYear": null, "Population": 56000}, {"GovernmentForm": "Republic", "GNP": 19008.0, "Code": "GTM", "Name": "Guatemala", "HeadOfState": "Alfonso Portillo Cabrera", "Region": "Central America", "Capital": 922, "Code2": "GT", "LifeExpectancy": 66.2, "LocalName": "Guatemala", "SurfaceArea": 108889.0, "GNPOld": 17797.0, "Continent": "North America", "IndepYear": 1821, "Population": 11385000}, {"GovernmentForm": "Overseas Department of France", "GNP": 681.0, "Code": "GUF", "Name": "French Guiana", "HeadOfState": "Jacques Chirac", "Region": "South America", "Capital": 3014, "Code2": "GF", "LifeExpectancy": 76.1, "LocalName": "Guyane fran\\u00e7aise", "SurfaceArea": 90000.0, "GNPOld": null, "Continent": "South America", "IndepYear": null, "Population": 181000}, {"GovernmentForm": "US Territory", "GNP": 1197.0, "Code": "GUM", "Name": "Guam", "HeadOfState": "George W. Bush", "Region": "Micronesia", "Capital": 921, "Code2": "GU", "LifeExpectancy": 77.8, "LocalName": "Guam", "SurfaceArea": 549.0, "GNPOld": 1136.0, "Continent": "Oceania", "IndepYear": null, "Population": 168000}, {"GovernmentForm": "Republic", "GNP": 722.0, "Code": "GUY", "Name": "Guyana", "HeadOfState": "Bharrat Jagdeo", "Region": "South America", "Capital": 928, "Code2": "GY", "LifeExpectancy": 64.0, "LocalName": "Guyana", "SurfaceArea": 214969.0, "GNPOld": 743.0, "Continent": "South America", "IndepYear": 1966, "Population": 861000}, {"GovernmentForm": "Special Administrative Region of China", "GNP": 166448.0, "Code": "HKG", "Name": "Hong Kong", "HeadOfState": "Jiang Zemin", "Region": "Eastern Asia", "Capital": 937, "Code2": "HK", "LifeExpectancy": 79.5, "LocalName": "Xianggang/Hong Kong", "SurfaceArea": 1075.0, "GNPOld": 173610.0, "Continent": "Asia", "IndepYear": null, "Population": 6782000}, {"GovernmentForm": "Territory of Australia", "GNP": 0.0, "Code": "HMD", "Name": "Heard Island and McDonald Islands", "HeadOfState": "Elisabeth II", "Region": "Antarctica", "Capital": null, "Code2": "HM", "LifeExpectancy": null, "LocalName": "Heard and McDonald Islands", "SurfaceArea": 359.0, "GNPOld": null, "Continent": "Antarctica", "IndepYear": null, "Population": 0}, {"GovernmentForm": "Republic", "GNP": 5333.0, "Code": "HND", "Name": "Honduras", "HeadOfState": "Carlos Roberto Flores Facuss\\u00e9", "Region": "Central America", "Capital": 933, "Code2": "HN", "LifeExpectancy": 69.9, "LocalName": "Honduras", "SurfaceArea": 112088.0, "GNPOld": 4697.0, "Continent": "North America", "IndepYear": 1838, "Population": 6485000}, {"GovernmentForm": "Republic", "GNP": 20208.0, "Code": "HRV", "Name": "Croatia", "HeadOfState": "\\u0160tipe Mesic", "Region": "Southern Europe", "Capital": 2409, "Code2": "HR", "LifeExpectancy": 73.7, "LocalName": "Hrvatska", "SurfaceArea": 56538.0, "GNPOld": 19300.0, "Continent": "Europe", "IndepYear": 1991, "Population": 4473000}, {"GovernmentForm": "Republic", "GNP": 3459.0, "Code": "HTI", "Name": "Haiti", "HeadOfState": "Jean-Bertrand Aristide", "Region": "Caribbean", "Capital": 929, "Code2": "HT", "LifeExpectancy": 49.2, "LocalName": "Ha\\u00efti/Dayti", "SurfaceArea": 27750.0, "GNPOld": 3107.0, "Continent": "North America", "IndepYear": 1804, "Population": 8222000}, {"GovernmentForm": "Republic", "GNP": 48267.0, "Code": "HUN", "Name": "Hungary", "HeadOfState": "Ferenc M\\u00e1dl", "Region": "Eastern Europe", "Capital": 3483, "Code2": "HU", "LifeExpectancy": 71.4, "LocalName": "Magyarorsz\\u00e1g", "SurfaceArea": 93030.0, "GNPOld": 45914.0, "Continent": "Europe", "IndepYear": 1918, "Population": 10043200}, {"GovernmentForm": "Republic", "GNP": 84982.0, "Code": "IDN", "Name": "Indonesia", "HeadOfState": "Abdurrahman Wahid", "Region": "Southeast Asia", "Capital": 939, "Code2": "ID", "LifeExpectancy": 68.0, "LocalName": "Indonesia", "SurfaceArea": 1904569.0, "GNPOld": 215002.0, "Continent": "Asia", "IndepYear": 1945, "Population": 212107000}, {"GovernmentForm": "Federal Republic", "GNP": 447114.0, "Code": "IND", "Name": "India", "HeadOfState": "Kocheril Raman Narayanan", "Region": "Southern and Central Asia", "Capital": 1109, "Code2": "IN", "LifeExpectancy": 62.5, "LocalName": "Bharat/India", "SurfaceArea": 3287263.0, "GNPOld": 430572.0, "Continent": "Asia", "IndepYear": 1947, "Population": 1013662000}, {"GovernmentForm": "Dependent Territory of the UK", "GNP": 0.0, "Code": "IOT", "Name": "British Indian Ocean Territory", "HeadOfState": "Elisabeth II", "Region": "Eastern Africa", "Capital": null, "Code2": "IO", "LifeExpectancy": null, "LocalName": "British Indian Ocean Territory", "SurfaceArea": 78.0, "GNPOld": null, "Continent": "Africa", "IndepYear": null, "Population": 0}, {"GovernmentForm": "Republic", "GNP": 75921.0, "Code": "IRL", "Name": "Ireland", "HeadOfState": "Mary McAleese", "Region": "British Islands", "Capital": 1447, "Code2": "IE", "LifeExpectancy": 76.8, "LocalName": "Ireland/\\u00c9ire", "SurfaceArea": 70273.0, "GNPOld": 73132.0, "Continent": "Europe", "IndepYear": 1921, "Population": 3775100}, {"GovernmentForm": "Islamic Republic", "GNP": 195746.0, "Code": "IRN", "Name": "Iran", "HeadOfState": "Ali Mohammad Khatami-Ardakani", "Region": "Southern and Central Asia", "Capital": 1380, "Code2": "IR", "LifeExpectancy": 69.7, "LocalName": "Iran", "SurfaceArea": 1648195.0, "GNPOld": 160151.0, "Continent": "Asia", "IndepYear": 1906, "Population": 67702000}, {"GovernmentForm": "Republic", "GNP": 11500.0, "Code": "IRQ", "Name": "Iraq", "HeadOfState": "Saddam Hussein al-Takriti", "Region": "Middle East", "Capital": 1365, "Code2": "IQ", "LifeExpectancy": 66.5, "LocalName": "Al-\\u00b4Iraq", "SurfaceArea": 438317.0, "GNPOld": null, "Continent": "Asia", "IndepYear": 1932, "Population": 23115000}, {"GovernmentForm": "Republic", "GNP": 8255.0, "Code": "ISL", "Name": "Iceland", "HeadOfState": "\\u00d3lafur Ragnar Gr\\u00edmsson", "Region": "Nordic Countries", "Capital": 1449, "Code2": "IS", "LifeExpectancy": 79.4, "LocalName": "\\u00cdsland", "SurfaceArea": 103000.0, "GNPOld": 7474.0, "Continent": "Europe", "IndepYear": 1944, "Population": 279000}, {"GovernmentForm": "Republic", "GNP": 97477.0, "Code": "ISR", "Name": "Israel", "HeadOfState": "Moshe Katzav", "Region": "Middle East", "Capital": 1450, "Code2": "IL", "LifeExpectancy": 78.6, "LocalName": "Yisra\\u2019el/Isra\\u2019il", "SurfaceArea": 21056.0, "GNPOld": 98577.0, "Continent": "Asia", "IndepYear": 1948, "Population": 6217000}, {"GovernmentForm": "Republic", "GNP": 1161755.0, "Code": "ITA", "Name": "Italy", "HeadOfState": "Carlo Azeglio Ciampi", "Region": "Southern Europe", "Capital": 1464, "Code2": "IT", "LifeExpectancy": 79.0, "LocalName": "Italia", "SurfaceArea": 301316.0, "GNPOld": 1145372.0, "Continent": "Europe", "IndepYear": 1861, "Population": 57680000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 6871.0, "Code": "JAM", "Name": "Jamaica", "HeadOfState": "Elisabeth II", "Region": "Caribbean", "Capital": 1530, "Code2": "JM", "LifeExpectancy": 75.2, "LocalName": "Jamaica", "SurfaceArea": 10990.0, "GNPOld": 6722.0, "Continent": "North America", "IndepYear": 1962, "Population": 2583000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 7526.0, "Code": "JOR", "Name": "Jordan", "HeadOfState": "Abdullah II", "Region": "Middle East", "Capital": 1786, "Code2": "JO", "LifeExpectancy": 77.4, "LocalName": "Al-Urdunn", "SurfaceArea": 88946.0, "GNPOld": 7051.0, "Continent": "Asia", "IndepYear": 1946, "Population": 5083000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 3787042.0, "Code": "JPN", "Name": "Japan", "HeadOfState": "Akihito", "Region": "Eastern Asia", "Capital": 1532, "Code2": "JP", "LifeExpectancy": 80.7, "LocalName": "Nihon/Nippon", "SurfaceArea": 377829.0, "GNPOld": 4192638.0, "Continent": "Asia", "IndepYear": -660, "Population": 126714000}, {"GovernmentForm": "Republic", "GNP": 24375.0, "Code": "KAZ", "Name": "Kazakstan", "HeadOfState": "Nursultan Nazarbajev", "Region": "Southern and Central Asia", "Capital": 1864, "Code2": "KZ", "LifeExpectancy": 63.2, "LocalName": "Qazaqstan", "SurfaceArea": 2724900.0, "GNPOld": 23383.0, "Continent": "Asia", "IndepYear": 1991, "Population": 16223000}, {"GovernmentForm": "Republic", "GNP": 9217.0, "Code": "KEN", "Name": "Kenya", "HeadOfState": "Daniel arap Moi", "Region": "Eastern Africa", "Capital": 1881, "Code2": "KE", "LifeExpectancy": 48.0, "LocalName": "Kenya", "SurfaceArea": 580367.0, "GNPOld": 10241.0, "Continent": "Africa", "IndepYear": 1963, "Population": 30080000}, {"GovernmentForm": "Republic", "GNP": 1626.0, "Code": "KGZ", "Name": "Kyrgyzstan", "HeadOfState": "Askar Akajev", "Region": "Southern and Central Asia", "Capital": 2253, "Code2": "KG", "LifeExpectancy": 63.4, "LocalName": "Kyrgyzstan", "SurfaceArea": 199900.0, "GNPOld": 1767.0, "Continent": "Asia", "IndepYear": 1991, "Population": 4699000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 5121.0, "Code": "KHM", "Name": "Cambodia", "HeadOfState": "Norodom Sihanouk", "Region": "Southeast Asia", "Capital": 1800, "Code2": "KH", "LifeExpectancy": 56.5, "LocalName": "K\\u00e2mpuch\\u00e9a", "SurfaceArea": 181035.0, "GNPOld": 5670.0, "Continent": "Asia", "IndepYear": 1953, "Population": 11168000}, {"GovernmentForm": "Republic", "GNP": 40.7, "Code": "KIR", "Name": "Kiribati", "HeadOfState": "Teburoro Tito", "Region": "Micronesia", "Capital": 2256, "Code2": "KI", "LifeExpectancy": 59.8, "LocalName": "Kiribati", "SurfaceArea": 726.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": 1979, "Population": 83000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 299.0, "Code": "KNA", "Name": "Saint Kitts and Nevis", "HeadOfState": "Elisabeth II", "Region": "Caribbean", "Capital": 3064, "Code2": "KN", "LifeExpectancy": 70.7, "LocalName": "Saint Kitts and Nevis", "SurfaceArea": 261.0, "GNPOld": null, "Continent": "North America", "IndepYear": 1983, "Population": 38000}, {"GovernmentForm": "Republic", "GNP": 320749.0, "Code": "KOR", "Name": "South Korea", "HeadOfState": "Kim Dae-jung", "Region": "Eastern Asia", "Capital": 2331, "Code2": "KR", "LifeExpectancy": 74.4, "LocalName": "Taehan Min\\u2019guk (Namhan)", "SurfaceArea": 99434.0, "GNPOld": 442544.0, "Continent": "Asia", "IndepYear": 1948, "Population": 46844000}, {"GovernmentForm": "Constitutional Monarchy (Emirate)", "GNP": 27037.0, "Code": "KWT", "Name": "Kuwait", "HeadOfState": "Jabir al-Ahmad al-Jabir al-Sabah", "Region": "Middle East", "Capital": 2429, "Code2": "KW", "LifeExpectancy": 76.1, "LocalName": "Al-Kuwayt", "SurfaceArea": 17818.0, "GNPOld": 30373.0, "Continent": "Asia", "IndepYear": 1961, "Population": 1972000}, {"GovernmentForm": "Republic", "GNP": 1292.0, "Code": "LAO", "Name": "Laos", "HeadOfState": "Khamtay Siphandone", "Region": "Southeast Asia", "Capital": 2432, "Code2": "LA", "LifeExpectancy": 53.1, "LocalName": "Lao", "SurfaceArea": 236800.0, "GNPOld": 1746.0, "Continent": "Asia", "IndepYear": 1953, "Population": 5433000}, {"GovernmentForm": "Republic", "GNP": 17121.0, "Code": "LBN", "Name": "Lebanon", "HeadOfState": "\\u00c9mile Lahoud", "Region": "Middle East", "Capital": 2438, "Code2": "LB", "LifeExpectancy": 71.3, "LocalName": "Lubnan", "SurfaceArea": 10400.0, "GNPOld": 15129.0, "Continent": "Asia", "IndepYear": 1941, "Population": 3282000}, {"GovernmentForm": "Republic", "GNP": 2012.0, "Code": "LBR", "Name": "Liberia", "HeadOfState": "Charles Taylor", "Region": "Western Africa", "Capital": 2440, "Code2": "LR", "LifeExpectancy": 51.0, "LocalName": "Liberia", "SurfaceArea": 111369.0, "GNPOld": null, "Continent": "Africa", "IndepYear": 1847, "Population": 3154000}, {"GovernmentForm": "Socialistic State", "GNP": 44806.0, "Code": "LBY", "Name": "Libyan Arab Jamahiriya", "HeadOfState": "Muammar al-Qadhafi", "Region": "Northern Africa", "Capital": 2441, "Code2": "LY", "LifeExpectancy": 75.5, "LocalName": "Libiya", "SurfaceArea": 1759540.0, "GNPOld": 40562.0, "Continent": "Africa", "IndepYear": 1951, "Population": 5605000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 571.0, "Code": "LCA", "Name": "Saint Lucia", "HeadOfState": "Elisabeth II", "Region": "Caribbean", "Capital": 3065, "Code2": "LC", "LifeExpectancy": 72.3, "LocalName": "Saint Lucia", "SurfaceArea": 622.0, "GNPOld": null, "Continent": "North America", "IndepYear": 1979, "Population": 154000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 1119.0, "Code": "LIE", "Name": "Liechtenstein", "HeadOfState": "Hans-Adam II", "Region": "Western Europe", "Capital": 2446, "Code2": "LI", "LifeExpectancy": 78.8, "LocalName": "Liechtenstein", "SurfaceArea": 160.0, "GNPOld": 1084.0, "Continent": "Europe", "IndepYear": 1806, "Population": 32300}, {"GovernmentForm": "Republic", "GNP": 15706.0, "Code": "LKA", "Name": "Sri Lanka", "HeadOfState": "Chandrika Kumaratunga", "Region": "Southern and Central Asia", "Capital": 3217, "Code2": "LK", "LifeExpectancy": 71.8, "LocalName": "Sri Lanka/Ilankai", "SurfaceArea": 65610.0, "GNPOld": 15091.0, "Continent": "Asia", "IndepYear": 1948, "Population": 18827000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 1061.0, "Code": "LSO", "Name": "Lesotho", "HeadOfState": "Letsie III", "Region": "Southern Africa", "Capital": 2437, "Code2": "LS", "LifeExpectancy": 50.8, "LocalName": "Lesotho", "SurfaceArea": 30355.0, "GNPOld": 1161.0, "Continent": "Africa", "IndepYear": 1966, "Population": 2153000}, {"GovernmentForm": "Republic", "GNP": 10692.0, "Code": "LTU", "Name": "Lithuania", "HeadOfState": "Valdas Adamkus", "Region": "Baltic Countries", "Capital": 2447, "Code2": "LT", "LifeExpectancy": 69.1, "LocalName": "Lietuva", "SurfaceArea": 65301.0, "GNPOld": 9585.0, "Continent": "Europe", "IndepYear": 1991, "Population": 3698500}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 16321.0, "Code": "LUX", "Name": "Luxembourg", "HeadOfState": "Henri", "Region": "Western Europe", "Capital": 2452, "Code2": "LU", "LifeExpectancy": 77.1, "LocalName": "Luxembourg/L\\u00ebtzebuerg", "SurfaceArea": 2586.0, "GNPOld": 15519.0, "Continent": "Europe", "IndepYear": 1867, "Population": 435700}, {"GovernmentForm": "Republic", "GNP": 6398.0, "Code": "LVA", "Name": "Latvia", "HeadOfState": "Vaira Vike-Freiberga", "Region": "Baltic Countries", "Capital": 2434, "Code2": "LV", "LifeExpectancy": 68.4, "LocalName": "Latvija", "SurfaceArea": 64589.0, "GNPOld": 5639.0, "Continent": "Europe", "IndepYear": 1991, "Population": 2424200}, {"GovernmentForm": "Special Administrative Region of China", "GNP": 5749.0, "Code": "MAC", "Name": "Macao", "HeadOfState": "Jiang Zemin", "Region": "Eastern Asia", "Capital": 2454, "Code2": "MO", "LifeExpectancy": 81.6, "LocalName": "Macau/Aomen", "SurfaceArea": 18.0, "GNPOld": 5940.0, "Continent": "Asia", "IndepYear": null, "Population": 473000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 36124.0, "Code": "MAR", "Name": "Morocco", "HeadOfState": "Mohammed VI", "Region": "Northern Africa", "Capital": 2486, "Code2": "MA", "LifeExpectancy": 69.1, "LocalName": "Al-Maghrib", "SurfaceArea": 446550.0, "GNPOld": 33514.0, "Continent": "Africa", "IndepYear": 1956, "Population": 28351000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 776.0, "Code": "MCO", "Name": "Monaco", "HeadOfState": "Rainier III", "Region": "Western Europe", "Capital": 2695, "Code2": "MC", "LifeExpectancy": 78.8, "LocalName": "Monaco", "SurfaceArea": 1.5, "GNPOld": null, "Continent": "Europe", "IndepYear": 1861, "Population": 34000}, {"GovernmentForm": "Republic", "GNP": 1579.0, "Code": "MDA", "Name": "Moldova", "HeadOfState": "Vladimir Voronin", "Region": "Eastern Europe", "Capital": 2690, "Code2": "MD", "LifeExpectancy": 64.5, "LocalName": "Moldova", "SurfaceArea": 33851.0, "GNPOld": 1872.0, "Continent": "Europe", "IndepYear": 1991, "Population": 4380000}, {"GovernmentForm": "Federal Republic", "GNP": 3750.0, "Code": "MDG", "Name": "Madagascar", "HeadOfState": "Didier Ratsiraka", "Region": "Eastern Africa", "Capital": 2455, "Code2": "MG", "LifeExpectancy": 55.0, "LocalName": "Madagasikara/Madagascar", "SurfaceArea": 587041.0, "GNPOld": 3545.0, "Continent": "Africa", "IndepYear": 1960, "Population": 15942000}, {"GovernmentForm": "Republic", "GNP": 199.0, "Code": "MDV", "Name": "Maldives", "HeadOfState": "Maumoon Abdul Gayoom", "Region": "Southern and Central Asia", "Capital": 2463, "Code2": "MV", "LifeExpectancy": 62.2, "LocalName": "Dhivehi Raajje/Maldives", "SurfaceArea": 298.0, "GNPOld": null, "Continent": "Asia", "IndepYear": 1965, "Population": 286000}, {"GovernmentForm": "Federal Republic", "GNP": 414972.0, "Code": "MEX", "Name": "Mexico", "HeadOfState": "Vicente Fox Quesada", "Region": "Central America", "Capital": 2515, "Code2": "MX", "LifeExpectancy": 71.5, "LocalName": "M\\u00e9xico", "SurfaceArea": 1958201.0, "GNPOld": 401461.0, "Continent": "North America", "IndepYear": 1810, "Population": 98881000}, {"GovernmentForm": "Republic", "GNP": 97.0, "Code": "MHL", "Name": "Marshall Islands", "HeadOfState": "Kessai Note", "Region": "Micronesia", "Capital": 2507, "Code2": "MH", "LifeExpectancy": 65.5, "LocalName": "Marshall Islands/Majol", "SurfaceArea": 181.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": 1990, "Population": 64000}, {"GovernmentForm": "Republic", "GNP": 1694.0, "Code": "MKD", "Name": "Macedonia", "HeadOfState": "Boris Trajkovski", "Region": "Southern Europe", "Capital": 2460, "Code2": "MK", "LifeExpectancy": 73.8, "LocalName": "Makedonija", "SurfaceArea": 25713.0, "GNPOld": 1915.0, "Continent": "Europe", "IndepYear": 1991, "Population": 2024000}, {"GovernmentForm": "Republic", "GNP": 2642.0, "Code": "MLI", "Name": "Mali", "HeadOfState": "Alpha Oumar Konar\\u00e9", "Region": "Western Africa", "Capital": 2482, "Code2": "ML", "LifeExpectancy": 46.7, "LocalName": "Mali", "SurfaceArea": 1240192.0, "GNPOld": 2453.0, "Continent": "Africa", "IndepYear": 1960, "Population": 11234000}, {"GovernmentForm": "Republic", "GNP": 3512.0, "Code": "MLT", "Name": "Malta", "HeadOfState": "Guido de Marco", "Region": "Southern Europe", "Capital": 2484, "Code2": "MT", "LifeExpectancy": 77.9, "LocalName": "Malta", "SurfaceArea": 316.0, "GNPOld": 3338.0, "Continent": "Europe", "IndepYear": 1964, "Population": 380200}, {"GovernmentForm": "Republic", "GNP": 180375.0, "Code": "MMR", "Name": "Myanmar", "HeadOfState": "kenraali Than Shwe", "Region": "Southeast Asia", "Capital": 2710, "Code2": "MM", "LifeExpectancy": 54.9, "LocalName": "Myanma Pye", "SurfaceArea": 676578.0, "GNPOld": 171028.0, "Continent": "Asia", "IndepYear": 1948, "Population": 45611000}, {"GovernmentForm": "Republic", "GNP": 1043.0, "Code": "MNG", "Name": "Mongolia", "HeadOfState": "Natsagiin Bagabandi", "Region": "Eastern Asia", "Capital": 2696, "Code2": "MN", "LifeExpectancy": 67.3, "LocalName": "Mongol Uls", "SurfaceArea": 1566500.0, "GNPOld": 933.0, "Continent": "Asia", "IndepYear": 1921, "Population": 2662000}, {"GovernmentForm": "Commonwealth of the US", "GNP": 0.0, "Code": "MNP", "Name": "Northern Mariana Islands", "HeadOfState": "George W. Bush", "Region": "Micronesia", "Capital": 2913, "Code2": "MP", "LifeExpectancy": 75.5, "LocalName": "Northern Mariana Islands", "SurfaceArea": 464.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": null, "Population": 78000}, {"GovernmentForm": "Republic", "GNP": 2891.0, "Code": "MOZ", "Name": "Mozambique", "HeadOfState": "Joaqu\\u00edm A. Chissano", "Region": "Eastern Africa", "Capital": 2698, "Code2": "MZ", "LifeExpectancy": 37.5, "LocalName": "Mo\\u00e7ambique", "SurfaceArea": 801590.0, "GNPOld": 2711.0, "Continent": "Africa", "IndepYear": 1975, "Population": 19680000}, {"GovernmentForm": "Republic", "GNP": 998.0, "Code": "MRT", "Name": "Mauritania", "HeadOfState": "Maaouiya Ould Sid\\u00b4Ahmad Taya", "Region": "Western Africa", "Capital": 2509, "Code2": "MR", "LifeExpectancy": 50.8, "LocalName": "Muritaniya/Mauritanie", "SurfaceArea": 1025520.0, "GNPOld": 1081.0, "Continent": "Africa", "IndepYear": 1960, "Population": 2670000}, {"GovernmentForm": "Dependent Territory of the UK", "GNP": 109.0, "Code": "MSR", "Name": "Montserrat", "HeadOfState": "Elisabeth II", "Region": "Caribbean", "Capital": 2697, "Code2": "MS", "LifeExpectancy": 78.0, "LocalName": "Montserrat", "SurfaceArea": 102.0, "GNPOld": null, "Continent": "North America", "IndepYear": null, "Population": 11000}, {"GovernmentForm": "Overseas Department of France", "GNP": 2731.0, "Code": "MTQ", "Name": "Martinique", "HeadOfState": "Jacques Chirac", "Region": "Caribbean", "Capital": 2508, "Code2": "MQ", "LifeExpectancy": 78.3, "LocalName": "Martinique", "SurfaceArea": 1102.0, "GNPOld": 2559.0, "Continent": "North America", "IndepYear": null, "Population": 395000}, {"GovernmentForm": "Republic", "GNP": 4251.0, "Code": "MUS", "Name": "Mauritius", "HeadOfState": "Cassam Uteem", "Region": "Eastern Africa", "Capital": 2511, "Code2": "MU", "LifeExpectancy": 71.0, "LocalName": "Mauritius", "SurfaceArea": 2040.0, "GNPOld": 4186.0, "Continent": "Africa", "IndepYear": 1968, "Population": 1158000}, {"GovernmentForm": "Republic", "GNP": 1687.0, "Code": "MWI", "Name": "Malawi", "HeadOfState": "Bakili Muluzi", "Region": "Eastern Africa", "Capital": 2462, "Code2": "MW", "LifeExpectancy": 37.6, "LocalName": "Malawi", "SurfaceArea": 118484.0, "GNPOld": 2527.0, "Continent": "Africa", "IndepYear": 1964, "Population": 10925000}, {"GovernmentForm": "Constitutional Monarchy, Federation", "GNP": 69213.0, "Code": "MYS", "Name": "Malaysia", "HeadOfState": "Salahuddin Abdul Aziz Shah Alhaj", "Region": "Southeast Asia", "Capital": 2464, "Code2": "MY", "LifeExpectancy": 70.8, "LocalName": "Malaysia", "SurfaceArea": 329758.0, "GNPOld": 97884.0, "Continent": "Asia", "IndepYear": 1957, "Population": 22244000}, {"GovernmentForm": "Territorial Collectivity of France", "GNP": 0.0, "Code": "MYT", "Name": "Mayotte", "HeadOfState": "Jacques Chirac", "Region": "Eastern Africa", "Capital": 2514, "Code2": "YT", "LifeExpectancy": 59.5, "LocalName": "Mayotte", "SurfaceArea": 373.0, "GNPOld": null, "Continent": "Africa", "IndepYear": null, "Population": 149000}, {"GovernmentForm": "Republic", "GNP": 3101.0, "Code": "NAM", "Name": "Namibia", "HeadOfState": "Sam Nujoma", "Region": "Southern Africa", "Capital": 2726, "Code2": "NA", "LifeExpectancy": 42.5, "LocalName": "Namibia", "SurfaceArea": 824292.0, "GNPOld": 3384.0, "Continent": "Africa", "IndepYear": 1990, "Population": 1726000}, {"GovernmentForm": "Nonmetropolitan Territory of France", "GNP": 3563.0, "Code": "NCL", "Name": "New Caledonia", "HeadOfState": "Jacques Chirac", "Region": "Melanesia", "Capital": 3493, "Code2": "NC", "LifeExpectancy": 72.8, "LocalName": "Nouvelle-Cal\\u00e9donie", "SurfaceArea": 18575.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": null, "Population": 214000}, {"GovernmentForm": "Republic", "GNP": 1706.0, "Code": "NER", "Name": "Niger", "HeadOfState": "Mamadou Tandja", "Region": "Western Africa", "Capital": 2738, "Code2": "NE", "LifeExpectancy": 41.3, "LocalName": "Niger", "SurfaceArea": 1267000.0, "GNPOld": 1580.0, "Continent": "Africa", "IndepYear": 1960, "Population": 10730000}, {"GovernmentForm": "Territory of Australia", "GNP": 0.0, "Code": "NFK", "Name": "Norfolk Island", "HeadOfState": "Elisabeth II", "Region": "Australia and New Zealand", "Capital": 2806, "Code2": "NF", "LifeExpectancy": null, "LocalName": "Norfolk Island", "SurfaceArea": 36.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": null, "Population": 2000}, {"GovernmentForm": "Federal Republic", "GNP": 65707.0, "Code": "NGA", "Name": "Nigeria", "HeadOfState": "Olusegun Obasanjo", "Region": "Western Africa", "Capital": 2754, "Code2": "NG", "LifeExpectancy": 51.6, "LocalName": "Nigeria", "SurfaceArea": 923768.0, "GNPOld": 58623.0, "Continent": "Africa", "IndepYear": 1960, "Population": 111506000}, {"GovernmentForm": "Republic", "GNP": 1988.0, "Code": "NIC", "Name": "Nicaragua", "HeadOfState": "Arnoldo Alem\\u00e1n Lacayo", "Region": "Central America", "Capital": 2734, "Code2": "NI", "LifeExpectancy": 68.7, "LocalName": "Nicaragua", "SurfaceArea": 130000.0, "GNPOld": 2023.0, "Continent": "North America", "IndepYear": 1838, "Population": 5074000}, {"GovernmentForm": "Nonmetropolitan Territory of New Zealand", "GNP": 0.0, "Code": "NIU", "Name": "Niue", "HeadOfState": "Elisabeth II", "Region": "Polynesia", "Capital": 2805, "Code2": "NU", "LifeExpectancy": null, "LocalName": "Niue", "SurfaceArea": 260.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": null, "Population": 2000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 371362.0, "Code": "NLD", "Name": "Netherlands", "HeadOfState": "Beatrix", "Region": "Western Europe", "Capital": 5, "Code2": "NL", "LifeExpectancy": 78.3, "LocalName": "Nederland", "SurfaceArea": 41526.0, "GNPOld": 360478.0, "Continent": "Europe", "IndepYear": 1581, "Population": 15864000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 145895.0, "Code": "NOR", "Name": "Norway", "HeadOfState": "Harald V", "Region": "Nordic Countries", "Capital": 2807, "Code2": "NO", "LifeExpectancy": 78.7, "LocalName": "Norge", "SurfaceArea": 323877.0, "GNPOld": 153370.0, "Continent": "Europe", "IndepYear": 1905, "Population": 4478500}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 4768.0, "Code": "NPL", "Name": "Nepal", "HeadOfState": "Gyanendra Bir Bikram", "Region": "Southern and Central Asia", "Capital": 2729, "Code2": "NP", "LifeExpectancy": 57.8, "LocalName": "Nepal", "SurfaceArea": 147181.0, "GNPOld": 4837.0, "Continent": "Asia", "IndepYear": 1769, "Population": 23930000}, {"GovernmentForm": "Republic", "GNP": 197.0, "Code": "NRU", "Name": "Nauru", "HeadOfState": "Bernard Dowiyogo", "Region": "Micronesia", "Capital": 2728, "Code2": "NR", "LifeExpectancy": 60.8, "LocalName": "Naoero/Nauru", "SurfaceArea": 21.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": 1968, "Population": 12000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 54669.0, "Code": "NZL", "Name": "New Zealand", "HeadOfState": "Elisabeth II", "Region": "Australia and New Zealand", "Capital": 3499, "Code2": "NZ", "LifeExpectancy": 77.8, "LocalName": "New Zealand/Aotearoa", "SurfaceArea": 270534.0, "GNPOld": 64960.0, "Continent": "Oceania", "IndepYear": 1907, "Population": 3862000}, {"GovernmentForm": "Monarchy (Sultanate)", "GNP": 16904.0, "Code": "OMN", "Name": "Oman", "HeadOfState": "Qabus ibn Sa\\u00b4id", "Region": "Middle East", "Capital": 2821, "Code2": "OM", "LifeExpectancy": 71.8, "LocalName": "\\u00b4Uman", "SurfaceArea": 309500.0, "GNPOld": 16153.0, "Continent": "Asia", "IndepYear": 1951, "Population": 2542000}, {"GovernmentForm": "Republic", "GNP": 61289.0, "Code": "PAK", "Name": "Pakistan", "HeadOfState": "Mohammad Rafiq Tarar", "Region": "Southern and Central Asia", "Capital": 2831, "Code2": "PK", "LifeExpectancy": 61.1, "LocalName": "Pakistan", "SurfaceArea": 796095.0, "GNPOld": 58549.0, "Continent": "Asia", "IndepYear": 1947, "Population": 156483000}, {"GovernmentForm": "Republic", "GNP": 9131.0, "Code": "PAN", "Name": "Panama", "HeadOfState": "Mireya Elisa Moscoso Rodr\\u00edguez", "Region": "Central America", "Capital": 2882, "Code2": "PA", "LifeExpectancy": 75.5, "LocalName": "Panam\\u00e1", "SurfaceArea": 75517.0, "GNPOld": 8700.0, "Continent": "North America", "IndepYear": 1903, "Population": 2856000}, {"GovernmentForm": "Dependent Territory of the UK", "GNP": 0.0, "Code": "PCN", "Name": "Pitcairn", "HeadOfState": "Elisabeth II", "Region": "Polynesia", "Capital": 2912, "Code2": "PN", "LifeExpectancy": null, "LocalName": "Pitcairn", "SurfaceArea": 49.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": null, "Population": 50}, {"GovernmentForm": "Republic", "GNP": 64140.0, "Code": "PER", "Name": "Peru", "HeadOfState": "Valentin Paniagua Corazao", "Region": "South America", "Capital": 2890, "Code2": "PE", "LifeExpectancy": 70.0, "LocalName": "Per\\u00fa/Piruw", "SurfaceArea": 1285216.0, "GNPOld": 65186.0, "Continent": "South America", "IndepYear": 1821, "Population": 25662000}, {"GovernmentForm": "Republic", "GNP": 65107.0, "Code": "PHL", "Name": "Philippines", "HeadOfState": "Gloria Macapagal-Arroyo", "Region": "Southeast Asia", "Capital": 766, "Code2": "PH", "LifeExpectancy": 67.5, "LocalName": "Pilipinas", "SurfaceArea": 300000.0, "GNPOld": 82239.0, "Continent": "Asia", "IndepYear": 1946, "Population": 75967000}, {"GovernmentForm": "Republic", "GNP": 105.0, "Code": "PLW", "Name": "Palau", "HeadOfState": "Kuniwo Nakamura", "Region": "Micronesia", "Capital": 2881, "Code2": "PW", "LifeExpectancy": 68.6, "LocalName": "Belau/Palau", "SurfaceArea": 459.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": 1994, "Population": 19000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 4988.0, "Code": "PNG", "Name": "Papua New Guinea", "HeadOfState": "Elisabeth II", "Region": "Melanesia", "Capital": 2884, "Code2": "PG", "LifeExpectancy": 63.1, "LocalName": "Papua New Guinea/Papua Niugini", "SurfaceArea": 462840.0, "GNPOld": 6328.0, "Continent": "Oceania", "IndepYear": 1975, "Population": 4807000}, {"GovernmentForm": "Republic", "GNP": 151697.0, "Code": "POL", "Name": "Poland", "HeadOfState": "Aleksander Kwasniewski", "Region": "Eastern Europe", "Capital": 2928, "Code2": "PL", "LifeExpectancy": 73.2, "LocalName": "Polska", "SurfaceArea": 323250.0, "GNPOld": 135636.0, "Continent": "Europe", "IndepYear": 1918, "Population": 38653600}, {"GovernmentForm": "Commonwealth of the US", "GNP": 34100.0, "Code": "PRI", "Name": "Puerto Rico", "HeadOfState": "George W. Bush", "Region": "Caribbean", "Capital": 2919, "Code2": "PR", "LifeExpectancy": 75.6, "LocalName": "Puerto Rico", "SurfaceArea": 8875.0, "GNPOld": 32100.0, "Continent": "North America", "IndepYear": null, "Population": 3869000}, {"GovernmentForm": "Socialistic Republic", "GNP": 5332.0, "Code": "PRK", "Name": "North Korea", "HeadOfState": "Kim Jong-il", "Region": "Eastern Asia", "Capital": 2318, "Code2": "KP", "LifeExpectancy": 70.7, "LocalName": "Choson Minjujuui In\\u00b4min Konghwaguk (Bukhan)", "SurfaceArea": 120538.0, "GNPOld": null, "Continent": "Asia", "IndepYear": 1948, "Population": 24039000}, {"GovernmentForm": "Republic", "GNP": 105954.0, "Code": "PRT", "Name": "Portugal", "HeadOfState": "Jorge Samp\\u00e3io", "Region": "Southern Europe", "Capital": 2914, "Code2": "PT", "LifeExpectancy": 75.8, "LocalName": "Portugal", "SurfaceArea": 91982.0, "GNPOld": 102133.0, "Continent": "Europe", "IndepYear": 1143, "Population": 9997600}, {"GovernmentForm": "Republic", "GNP": 8444.0, "Code": "PRY", "Name": "Paraguay", "HeadOfState": "Luis \\u00c1ngel Gonz\\u00e1lez Macchi", "Region": "South America", "Capital": 2885, "Code2": "PY", "LifeExpectancy": 73.7, "LocalName": "Paraguay", "SurfaceArea": 406752.0, "GNPOld": 9555.0, "Continent": "South America", "IndepYear": 1811, "Population": 5496000}, {"GovernmentForm": "Autonomous Area", "GNP": 4173.0, "Code": "PSE", "Name": "Palestine", "HeadOfState": "Yasser (Yasir) Arafat", "Region": "Middle East", "Capital": 4074, "Code2": "PS", "LifeExpectancy": 71.4, "LocalName": "Filastin", "SurfaceArea": 6257.0, "GNPOld": null, "Continent": "Asia", "IndepYear": null, "Population": 3101000}, {"GovernmentForm": "Nonmetropolitan Territory of France", "GNP": 818.0, "Code": "PYF", "Name": "French Polynesia", "HeadOfState": "Jacques Chirac", "Region": "Polynesia", "Capital": 3016, "Code2": "PF", "LifeExpectancy": 74.8, "LocalName": "Polyn\\u00e9sie fran\\u00e7aise", "SurfaceArea": 4000.0, "GNPOld": 781.0, "Continent": "Oceania", "IndepYear": null, "Population": 235000}, {"GovernmentForm": "Monarchy", "GNP": 9472.0, "Code": "QAT", "Name": "Qatar", "HeadOfState": "Hamad ibn Khalifa al-Thani", "Region": "Middle East", "Capital": 2973, "Code2": "QA", "LifeExpectancy": 72.4, "LocalName": "Qatar", "SurfaceArea": 11000.0, "GNPOld": 8920.0, "Continent": "Asia", "IndepYear": 1971, "Population": 599000}, {"GovernmentForm": "Overseas Department of France", "GNP": 8287.0, "Code": "REU", "Name": "R\\u00e9union", "HeadOfState": "Jacques Chirac", "Region": "Eastern Africa", "Capital": 3017, "Code2": "RE", "LifeExpectancy": 72.7, "LocalName": "R\\u00e9union", "SurfaceArea": 2510.0, "GNPOld": 7988.0, "Continent": "Africa", "IndepYear": null, "Population": 699000}, {"GovernmentForm": "Republic", "GNP": 38158.0, "Code": "ROM", "Name": "Romania", "HeadOfState": "Ion Iliescu", "Region": "Eastern Europe", "Capital": 3018, "Code2": "RO", "LifeExpectancy": 69.9, "LocalName": "Rom\\u00e2nia", "SurfaceArea": 238391.0, "GNPOld": 34843.0, "Continent": "Europe", "IndepYear": 1878, "Population": 22455500}, {"GovernmentForm": "Federal Republic", "GNP": 276608.0, "Code": "RUS", "Name": "Russian Federation", "HeadOfState": "Vladimir Putin", "Region": "Eastern Europe", "Capital": 3580, "Code2": "RU", "LifeExpectancy": 67.2, "LocalName": "Rossija", "SurfaceArea": 17075400.0, "GNPOld": 442989.0, "Continent": "Europe", "IndepYear": 1991, "Population": 146934000}, {"GovernmentForm": "Republic", "GNP": 2036.0, "Code": "RWA", "Name": "Rwanda", "HeadOfState": "Paul Kagame", "Region": "Eastern Africa", "Capital": 3047, "Code2": "RW", "LifeExpectancy": 39.3, "LocalName": "Rwanda/Urwanda", "SurfaceArea": 26338.0, "GNPOld": 1863.0, "Continent": "Africa", "IndepYear": 1962, "Population": 7733000}, {"GovernmentForm": "Monarchy", "GNP": 137635.0, "Code": "SAU", "Name": "Saudi Arabia", "HeadOfState": "Fahd ibn Abdul-Aziz al-Sa\\u00b4ud", "Region": "Middle East", "Capital": 3173, "Code2": "SA", "LifeExpectancy": 67.8, "LocalName": "Al-\\u00b4Arabiya as-Sa\\u00b4udiya", "SurfaceArea": 2149690.0, "GNPOld": 146171.0, "Continent": "Asia", "IndepYear": 1932, "Population": 21607000}, {"GovernmentForm": "Islamic Republic", "GNP": 10162.0, "Code": "SDN", "Name": "Sudan", "HeadOfState": "Omar Hassan Ahmad al-Bashir", "Region": "Northern Africa", "Capital": 3225, "Code2": "SD", "LifeExpectancy": 56.6, "LocalName": "As-Sudan", "SurfaceArea": 2505813.0, "GNPOld": null, "Continent": "Africa", "IndepYear": 1956, "Population": 29490000}, {"GovernmentForm": "Republic", "GNP": 4787.0, "Code": "SEN", "Name": "Senegal", "HeadOfState": "Abdoulaye Wade", "Region": "Western Africa", "Capital": 3198, "Code2": "SN", "LifeExpectancy": 62.2, "LocalName": "S\\u00e9n\\u00e9gal/Sounougal", "SurfaceArea": 196722.0, "GNPOld": 4542.0, "Continent": "Africa", "IndepYear": 1960, "Population": 9481000}, {"GovernmentForm": "Republic", "GNP": 86503.0, "Code": "SGP", "Name": "Singapore", "HeadOfState": "Sellapan Rama Nathan", "Region": "Southeast Asia", "Capital": 3208, "Code2": "SG", "LifeExpectancy": 80.1, "LocalName": "Singapore/Singapura/Xinjiapo/Singapur", "SurfaceArea": 618.0, "GNPOld": 96318.0, "Continent": "Asia", "IndepYear": 1965, "Population": 3567000}, {"GovernmentForm": "Dependent Territory of the UK", "GNP": 0.0, "Code": "SGS", "Name": "South Georgia and the South Sandwich Islands", "HeadOfState": "Elisabeth II", "Region": "Antarctica", "Capital": null, "Code2": "GS", "LifeExpectancy": null, "LocalName": "South Georgia and the South Sandwich Islands", "SurfaceArea": 3903.0, "GNPOld": null, "Continent": "Antarctica", "IndepYear": null, "Population": 0}, {"GovernmentForm": "Dependent Territory of the UK", "GNP": 0.0, "Code": "SHN", "Name": "Saint Helena", "HeadOfState": "Elisabeth II", "Region": "Western Africa", "Capital": 3063, "Code2": "SH", "LifeExpectancy": 76.8, "LocalName": "Saint Helena", "SurfaceArea": 314.0, "GNPOld": null, "Continent": "Africa", "IndepYear": null, "Population": 6000}, {"GovernmentForm": "Dependent Territory of Norway", "GNP": 0.0, "Code": "SJM", "Name": "Svalbard and Jan Mayen", "HeadOfState": "Harald V", "Region": "Nordic Countries", "Capital": 938, "Code2": "SJ", "LifeExpectancy": null, "LocalName": "Svalbard og Jan Mayen", "SurfaceArea": 62422.0, "GNPOld": null, "Continent": "Europe", "IndepYear": null, "Population": 3200}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 182.0, "Code": "SLB", "Name": "Solomon Islands", "HeadOfState": "Elisabeth II", "Region": "Melanesia", "Capital": 3161, "Code2": "SB", "LifeExpectancy": 71.3, "LocalName": "Solomon Islands", "SurfaceArea": 28896.0, "GNPOld": 220.0, "Continent": "Oceania", "IndepYear": 1978, "Population": 444000}, {"GovernmentForm": "Republic", "GNP": 746.0, "Code": "SLE", "Name": "Sierra Leone", "HeadOfState": "Ahmed Tejan Kabbah", "Region": "Western Africa", "Capital": 3207, "Code2": "SL", "LifeExpectancy": 45.3, "LocalName": "Sierra Leone", "SurfaceArea": 71740.0, "GNPOld": 858.0, "Continent": "Africa", "IndepYear": 1961, "Population": 4854000}, {"GovernmentForm": "Republic", "GNP": 11863.0, "Code": "SLV", "Name": "El Salvador", "HeadOfState": "Francisco Guillermo Flores P\\u00e9rez", "Region": "Central America", "Capital": 645, "Code2": "SV", "LifeExpectancy": 69.7, "LocalName": "El Salvador", "SurfaceArea": 21041.0, "GNPOld": 11203.0, "Continent": "North America", "IndepYear": 1841, "Population": 6276000}, {"GovernmentForm": "Republic", "GNP": 510.0, "Code": "SMR", "Name": "San Marino", "HeadOfState": null, "Region": "Southern Europe", "Capital": 3171, "Code2": "SM", "LifeExpectancy": 81.1, "LocalName": "San Marino", "SurfaceArea": 61.0, "GNPOld": null, "Continent": "Europe", "IndepYear": 885, "Population": 27000}, {"GovernmentForm": "Republic", "GNP": 935.0, "Code": "SOM", "Name": "Somalia", "HeadOfState": "Abdiqassim Salad Hassan", "Region": "Eastern Africa", "Capital": 3214, "Code2": "SO", "LifeExpectancy": 46.2, "LocalName": "Soomaaliya", "SurfaceArea": 637657.0, "GNPOld": null, "Continent": "Africa", "IndepYear": 1960, "Population": 10097000}, {"GovernmentForm": "Territorial Collectivity of France", "GNP": 0.0, "Code": "SPM", "Name": "Saint Pierre and Miquelon", "HeadOfState": "Jacques Chirac", "Region": "North America", "Capital": 3067, "Code2": "PM", "LifeExpectancy": 77.6, "LocalName": "Saint-Pierre-et-Miquelon", "SurfaceArea": 242.0, "GNPOld": null, "Continent": "North America", "IndepYear": null, "Population": 7000}, {"GovernmentForm": "Republic", "GNP": 6.0, "Code": "STP", "Name": "Sao Tome and Principe", "HeadOfState": "Miguel Trovoada", "Region": "Central Africa", "Capital": 3172, "Code2": "ST", "LifeExpectancy": 65.3, "LocalName": "S\\u00e3o Tom\\u00e9 e Pr\\u00edncipe", "SurfaceArea": 964.0, "GNPOld": null, "Continent": "Africa", "IndepYear": 1975, "Population": 147000}, {"GovernmentForm": "Republic", "GNP": 870.0, "Code": "SUR", "Name": "Suriname", "HeadOfState": "Ronald Venetiaan", "Region": "South America", "Capital": 3243, "Code2": "SR", "LifeExpectancy": 71.4, "LocalName": "Suriname", "SurfaceArea": 163265.0, "GNPOld": 706.0, "Continent": "South America", "IndepYear": 1975, "Population": 417000}, {"GovernmentForm": "Republic", "GNP": 20594.0, "Code": "SVK", "Name": "Slovakia", "HeadOfState": "Rudolf Schuster", "Region": "Eastern Europe", "Capital": 3209, "Code2": "SK", "LifeExpectancy": 73.7, "LocalName": "Slovensko", "SurfaceArea": 49012.0, "GNPOld": 19452.0, "Continent": "Europe", "IndepYear": 1993, "Population": 5398700}, {"GovernmentForm": "Republic", "GNP": 19756.0, "Code": "SVN", "Name": "Slovenia", "HeadOfState": "Milan Kucan", "Region": "Southern Europe", "Capital": 3212, "Code2": "SI", "LifeExpectancy": 74.9, "LocalName": "Slovenija", "SurfaceArea": 20256.0, "GNPOld": 18202.0, "Continent": "Europe", "IndepYear": 1991, "Population": 1987800}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 226492.0, "Code": "SWE", "Name": "Sweden", "HeadOfState": "Carl XVI Gustaf", "Region": "Nordic Countries", "Capital": 3048, "Code2": "SE", "LifeExpectancy": 79.6, "LocalName": "Sverige", "SurfaceArea": 449964.0, "GNPOld": 227757.0, "Continent": "Europe", "IndepYear": 836, "Population": 8861400}, {"GovernmentForm": "Monarchy", "GNP": 1206.0, "Code": "SWZ", "Name": "Swaziland", "HeadOfState": "Mswati III", "Region": "Southern Africa", "Capital": 3244, "Code2": "SZ", "LifeExpectancy": 40.4, "LocalName": "kaNgwane", "SurfaceArea": 17364.0, "GNPOld": 1312.0, "Continent": "Africa", "IndepYear": 1968, "Population": 1008000}, {"GovernmentForm": "Republic", "GNP": 536.0, "Code": "SYC", "Name": "Seychelles", "HeadOfState": "France-Albert Ren\\u00e9", "Region": "Eastern Africa", "Capital": 3206, "Code2": "SC", "LifeExpectancy": 70.4, "LocalName": "Sesel/Seychelles", "SurfaceArea": 455.0, "GNPOld": 539.0, "Continent": "Africa", "IndepYear": 1976, "Population": 77000}, {"GovernmentForm": "Republic", "GNP": 65984.0, "Code": "SYR", "Name": "Syria", "HeadOfState": "Bashar al-Assad", "Region": "Middle East", "Capital": 3250, "Code2": "SY", "LifeExpectancy": 68.5, "LocalName": "Suriya", "SurfaceArea": 185180.0, "GNPOld": 64926.0, "Continent": "Asia", "IndepYear": 1941, "Population": 16125000}, {"GovernmentForm": "Dependent Territory of the UK", "GNP": 96.0, "Code": "TCA", "Name": "Turks and Caicos Islands", "HeadOfState": "Elisabeth II", "Region": "Caribbean", "Capital": 3423, "Code2": "TC", "LifeExpectancy": 73.3, "LocalName": "The Turks and Caicos Islands", "SurfaceArea": 430.0, "GNPOld": null, "Continent": "North America", "IndepYear": null, "Population": 17000}, {"GovernmentForm": "Republic", "GNP": 1208.0, "Code": "TCD", "Name": "Chad", "HeadOfState": "Idriss D\\u00e9by", "Region": "Central Africa", "Capital": 3337, "Code2": "TD", "LifeExpectancy": 50.5, "LocalName": "Tchad/Tshad", "SurfaceArea": 1284000.0, "GNPOld": 1102.0, "Continent": "Africa", "IndepYear": 1960, "Population": 7651000}, {"GovernmentForm": "Republic", "GNP": 1449.0, "Code": "TGO", "Name": "Togo", "HeadOfState": "Gnassingb\\u00e9 Eyad\\u00e9ma", "Region": "Western Africa", "Capital": 3332, "Code2": "TG", "LifeExpectancy": 54.7, "LocalName": "Togo", "SurfaceArea": 56785.0, "GNPOld": 1400.0, "Continent": "Africa", "IndepYear": 1960, "Population": 4629000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 116416.0, "Code": "THA", "Name": "Thailand", "HeadOfState": "Bhumibol Adulyadej", "Region": "Southeast Asia", "Capital": 3320, "Code2": "TH", "LifeExpectancy": 68.6, "LocalName": "Prathet Thai", "SurfaceArea": 513115.0, "GNPOld": 153907.0, "Continent": "Asia", "IndepYear": 1350, "Population": 61399000}, {"GovernmentForm": "Republic", "GNP": 1990.0, "Code": "TJK", "Name": "Tajikistan", "HeadOfState": "Emomali Rahmonov", "Region": "Southern and Central Asia", "Capital": 3261, "Code2": "TJ", "LifeExpectancy": 64.1, "LocalName": "To\\u00e7ikiston", "SurfaceArea": 143100.0, "GNPOld": 1056.0, "Continent": "Asia", "IndepYear": 1991, "Population": 6188000}, {"GovernmentForm": "Nonmetropolitan Territory of New Zealand", "GNP": 0.0, "Code": "TKL", "Name": "Tokelau", "HeadOfState": "Elisabeth II", "Region": "Polynesia", "Capital": 3333, "Code2": "TK", "LifeExpectancy": null, "LocalName": "Tokelau", "SurfaceArea": 12.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": null, "Population": 2000}, {"GovernmentForm": "Republic", "GNP": 4397.0, "Code": "TKM", "Name": "Turkmenistan", "HeadOfState": "Saparmurad Nijazov", "Region": "Southern and Central Asia", "Capital": 3419, "Code2": "TM", "LifeExpectancy": 60.9, "LocalName": "T\\u00fcrkmenostan", "SurfaceArea": 488100.0, "GNPOld": 2000.0, "Continent": "Asia", "IndepYear": 1991, "Population": 4459000}, {"GovernmentForm": "Administrated by the UN", "GNP": 0.0, "Code": "TMP", "Name": "East Timor", "HeadOfState": "Jos\\u00e9 Alexandre Gusm\\u00e3o", "Region": "Southeast Asia", "Capital": 1522, "Code2": "TP", "LifeExpectancy": 46.0, "LocalName": "Timor Timur", "SurfaceArea": 14874.0, "GNPOld": null, "Continent": "Asia", "IndepYear": null, "Population": 885000}, {"GovernmentForm": "Monarchy", "GNP": 146.0, "Code": "TON", "Name": "Tonga", "HeadOfState": "Taufa'ahau Tupou IV", "Region": "Polynesia", "Capital": 3334, "Code2": "TO", "LifeExpectancy": 67.9, "LocalName": "Tonga", "SurfaceArea": 650.0, "GNPOld": 170.0, "Continent": "Oceania", "IndepYear": 1970, "Population": 99000}, {"GovernmentForm": "Republic", "GNP": 6232.0, "Code": "TTO", "Name": "Trinidad and Tobago", "HeadOfState": "Arthur N. R. Robinson", "Region": "Caribbean", "Capital": 3336, "Code2": "TT", "LifeExpectancy": 68.0, "LocalName": "Trinidad and Tobago", "SurfaceArea": 5130.0, "GNPOld": 5867.0, "Continent": "North America", "IndepYear": 1962, "Population": 1295000}, {"GovernmentForm": "Republic", "GNP": 20026.0, "Code": "TUN", "Name": "Tunisia", "HeadOfState": "Zine al-Abidine Ben Ali", "Region": "Northern Africa", "Capital": 3349, "Code2": "TN", "LifeExpectancy": 73.7, "LocalName": "Tunis/Tunisie", "SurfaceArea": 163610.0, "GNPOld": 18898.0, "Continent": "Africa", "IndepYear": 1956, "Population": 9586000}, {"GovernmentForm": "Republic", "GNP": 210721.0, "Code": "TUR", "Name": "Turkey", "HeadOfState": "Ahmet Necdet Sezer", "Region": "Middle East", "Capital": 3358, "Code2": "TR", "LifeExpectancy": 71.0, "LocalName": "T\\u00fcrkiye", "SurfaceArea": 774815.0, "GNPOld": 189122.0, "Continent": "Asia", "IndepYear": 1923, "Population": 66591000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 6.0, "Code": "TUV", "Name": "Tuvalu", "HeadOfState": "Elisabeth II", "Region": "Polynesia", "Capital": 3424, "Code2": "TV", "LifeExpectancy": 66.3, "LocalName": "Tuvalu", "SurfaceArea": 26.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": 1978, "Population": 12000}, {"GovernmentForm": "Republic", "GNP": 256254.0, "Code": "TWN", "Name": "Taiwan", "HeadOfState": "Chen Shui-bian", "Region": "Eastern Asia", "Capital": 3263, "Code2": "TW", "LifeExpectancy": 76.4, "LocalName": "T\\u2019ai-wan", "SurfaceArea": 36188.0, "GNPOld": 263451.0, "Continent": "Asia", "IndepYear": 1945, "Population": 22256000}, {"GovernmentForm": "Republic", "GNP": 8005.0, "Code": "TZA", "Name": "Tanzania", "HeadOfState": "Benjamin William Mkapa", "Region": "Eastern Africa", "Capital": 3306, "Code2": "TZ", "LifeExpectancy": 52.3, "LocalName": "Tanzania", "SurfaceArea": 883749.0, "GNPOld": 7388.0, "Continent": "Africa", "IndepYear": 1961, "Population": 33517000}, {"GovernmentForm": "Republic", "GNP": 6313.0, "Code": "UGA", "Name": "Uganda", "HeadOfState": "Yoweri Museveni", "Region": "Eastern Africa", "Capital": 3425, "Code2": "UG", "LifeExpectancy": 42.9, "LocalName": "Uganda", "SurfaceArea": 241038.0, "GNPOld": 6887.0, "Continent": "Africa", "IndepYear": 1962, "Population": 21778000}, {"GovernmentForm": "Republic", "GNP": 42168.0, "Code": "UKR", "Name": "Ukraine", "HeadOfState": "Leonid Kut\\u0161ma", "Region": "Eastern Europe", "Capital": 3426, "Code2": "UA", "LifeExpectancy": 66.0, "LocalName": "Ukrajina", "SurfaceArea": 603700.0, "GNPOld": 49677.0, "Continent": "Europe", "IndepYear": 1991, "Population": 50456000}, {"GovernmentForm": "Dependent Territory of the US", "GNP": 0.0, "Code": "UMI", "Name": "United States Minor Outlying Islands", "HeadOfState": "George W. Bush", "Region": "Micronesia/Caribbean", "Capital": null, "Code2": "UM", "LifeExpectancy": null, "LocalName": "United States Minor Outlying Islands", "SurfaceArea": 16.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": null, "Population": 0}, {"GovernmentForm": "Republic", "GNP": 20831.0, "Code": "URY", "Name": "Uruguay", "HeadOfState": "Jorge Batlle Ib\\u00e1\\u00f1ez", "Region": "South America", "Capital": 3492, "Code2": "UY", "LifeExpectancy": 75.2, "LocalName": "Uruguay", "SurfaceArea": 175016.0, "GNPOld": 19967.0, "Continent": "South America", "IndepYear": 1828, "Population": 3337000}, {"GovernmentForm": "Federal Republic", "GNP": 8510700.0, "Code": "USA", "Name": "United States", "HeadOfState": "George W. Bush", "Region": "North America", "Capital": 3813, "Code2": "US", "LifeExpectancy": 77.1, "LocalName": "United States", "SurfaceArea": 9363520.0, "GNPOld": 8110900.0, "Continent": "North America", "IndepYear": 1776, "Population": 278357000}, {"GovernmentForm": "Republic", "GNP": 14194.0, "Code": "UZB", "Name": "Uzbekistan", "HeadOfState": "Islam Karimov", "Region": "Southern and Central Asia", "Capital": 3503, "Code2": "UZ", "LifeExpectancy": 63.7, "LocalName": "Uzbekiston", "SurfaceArea": 447400.0, "GNPOld": 21300.0, "Continent": "Asia", "IndepYear": 1991, "Population": 24318000}, {"GovernmentForm": "Independent Church State", "GNP": 9.0, "Code": "VAT", "Name": "Holy See (Vatican City State)", "HeadOfState": "Johannes Paavali II", "Region": "Southern Europe", "Capital": 3538, "Code2": "VA", "LifeExpectancy": null, "LocalName": "Santa Sede/Citt\\u00e0 del Vaticano", "SurfaceArea": 0.4, "GNPOld": null, "Continent": "Europe", "IndepYear": 1929, "Population": 1000}, {"GovernmentForm": "Constitutional Monarchy", "GNP": 285.0, "Code": "VCT", "Name": "Saint Vincent and the Grenadines", "HeadOfState": "Elisabeth II", "Region": "Caribbean", "Capital": 3066, "Code2": "VC", "LifeExpectancy": 72.3, "LocalName": "Saint Vincent and the Grenadines", "SurfaceArea": 388.0, "GNPOld": null, "Continent": "North America", "IndepYear": 1979, "Population": 114000}, {"GovernmentForm": "Federal Republic", "GNP": 95023.0, "Code": "VEN", "Name": "Venezuela", "HeadOfState": "Hugo Ch\\u00e1vez Fr\\u00edas", "Region": "South America", "Capital": 3539, "Code2": "VE", "LifeExpectancy": 73.1, "LocalName": "Venezuela", "SurfaceArea": 912050.0, "GNPOld": 88434.0, "Continent": "South America", "IndepYear": 1811, "Population": 24170000}, {"GovernmentForm": "Dependent Territory of the UK", "GNP": 612.0, "Code": "VGB", "Name": "Virgin Islands, British", "HeadOfState": "Elisabeth II", "Region": "Caribbean", "Capital": 537, "Code2": "VG", "LifeExpectancy": 75.4, "LocalName": "British Virgin Islands", "SurfaceArea": 151.0, "GNPOld": 573.0, "Continent": "North America", "IndepYear": null, "Population": 21000}, {"GovernmentForm": "US Territory", "GNP": 0.0, "Code": "VIR", "Name": "Virgin Islands, U.S.", "HeadOfState": "George W. Bush", "Region": "Caribbean", "Capital": 4067, "Code2": "VI", "LifeExpectancy": 78.1, "LocalName": "Virgin Islands of the United States", "SurfaceArea": 347.0, "GNPOld": null, "Continent": "North America", "IndepYear": null, "Population": 93000}, {"GovernmentForm": "Socialistic Republic", "GNP": 21929.0, "Code": "VNM", "Name": "Vietnam", "HeadOfState": "Tr\\u00e2n Duc Luong", "Region": "Southeast Asia", "Capital": 3770, "Code2": "VN", "LifeExpectancy": 69.3, "LocalName": "Vi\\u00eat Nam", "SurfaceArea": 331689.0, "GNPOld": 22834.0, "Continent": "Asia", "IndepYear": 1945, "Population": 79832000}, {"GovernmentForm": "Republic", "GNP": 261.0, "Code": "VUT", "Name": "Vanuatu", "HeadOfState": "John Bani", "Region": "Melanesia", "Capital": 3537, "Code2": "VU", "LifeExpectancy": 60.6, "LocalName": "Vanuatu", "SurfaceArea": 12189.0, "GNPOld": 246.0, "Continent": "Oceania", "IndepYear": 1980, "Population": 190000}, {"GovernmentForm": "Nonmetropolitan Territory of France", "GNP": 0.0, "Code": "WLF", "Name": "Wallis and Futuna", "HeadOfState": "Jacques Chirac", "Region": "Polynesia", "Capital": 3536, "Code2": "WF", "LifeExpectancy": null, "LocalName": "Wallis-et-Futuna", "SurfaceArea": 200.0, "GNPOld": null, "Continent": "Oceania", "IndepYear": null, "Population": 15000}, {"GovernmentForm": "Parlementary Monarchy", "GNP": 141.0, "Code": "WSM", "Name": "Samoa", "HeadOfState": "Malietoa Tanumafili II", "Region": "Polynesia", "Capital": 3169, "Code2": "WS", "LifeExpectancy": 69.2, "LocalName": "Samoa", "SurfaceArea": 2831.0, "GNPOld": 157.0, "Continent": "Oceania", "IndepYear": 1962, "Population": 180000}, {"GovernmentForm": "Republic", "GNP": 6041.0, "Code": "YEM", "Name": "Yemen", "HeadOfState": "Ali Abdallah Salih", "Region": "Middle East", "Capital": 1780, "Code2": "YE", "LifeExpectancy": 59.8, "LocalName": "Al-Yaman", "SurfaceArea": 527968.0, "GNPOld": 5729.0, "Continent": "Asia", "IndepYear": 1918, "Population": 18112000}, {"GovernmentForm": "Federal Republic", "GNP": 17000.0, "Code": "YUG", "Name": "Yugoslavia", "HeadOfState": "Vojislav Ko\\u0161tunica", "Region": "Southern Europe", "Capital": 1792, "Code2": "YU", "LifeExpectancy": 72.4, "LocalName": "Jugoslavija", "SurfaceArea": 102173.0, "GNPOld": null, "Continent": "Europe", "IndepYear": 1918, "Population": 10640000}, {"GovernmentForm": "Republic", "GNP": 116729.0, "Code": "ZAF", "Name": "South Africa", "HeadOfState": "Thabo Mbeki", "Region": "Southern Africa", "Capital": 716, "Code2": "ZA", "LifeExpectancy": 51.1, "LocalName": "South Africa", "SurfaceArea": 1221037.0, "GNPOld": 129092.0, "Continent": "Africa", "IndepYear": 1910, "Population": 40377000}, {"GovernmentForm": "Republic", "GNP": 3377.0, "Code": "ZMB", "Name": "Zambia", "HeadOfState": "Frederick Chiluba", "Region": "Eastern Africa", "Capital": 3162, "Code2": "ZM", "LifeExpectancy": 37.2, "LocalName": "Zambia", "SurfaceArea": 752618.0, "GNPOld": 3922.0, "Continent": "Africa", "IndepYear": 1964, "Population": 9169000}, {"GovernmentForm": "Republic", "GNP": 5951.0, "Code": "ZWE", "Name": "Zimbabwe", "HeadOfState": "Robert G. Mugabe", "Region": "Eastern Africa", "Capital": 4068, "Code2": "ZW", "LifeExpectancy": 37.8, "LocalName": "Zimbabwe", "SurfaceArea": 390757.0, "GNPOld": 8670.0, "Continent": "Africa", "IndepYear": 1980, "Population": 11669000}], "columns": [{"type": "string", "friendly_name": "Code", "name": "Code"}, {"type": "string", "friendly_name": "Name", "name": "Name"}, {"type": "string", "friendly_name": "Continent", "name": "Continent"}, {"type": "string", "friendly_name": "Region", "name": "Region"}, {"type": "float", "friendly_name": "SurfaceArea", "name": "SurfaceArea"}, {"type": "integer", "friendly_name": "IndepYear", "name": "IndepYear"}, {"type": "integer", "friendly_name": "Population", "name": "Population"}, {"type": "float", "friendly_name": "LifeExpectancy", "name": "LifeExpectancy"}, {"type": "float", "friendly_name": "GNP", "name": "GNP"}, {"type": "float", "friendly_name": "GNPOld", "name": "GNPOld"}, {"type": "string", "friendly_name": "LocalName", "name": "LocalName"}, {"type": "string", "friendly_name": "GovernmentForm", "name": "GovernmentForm"}, {"type": "string", "friendly_name": "HeadOfState", "name": "HeadOfState"}, {"type": "integer", "friendly_name": "Capital", "name": "Capital"}, {"type": "string", "friendly_name": "Code2", "name": "Code2"}]}	0.00667619705200195312	2021-11-03 08:26:13.333292+00
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
2021-11-03 08:26:19.25375+00	2021-11-03 08:05:43.330472+00	1	1	admin	admin@localhost.localdomain	\N	$6$rounds=109130$71Hfiu6x9HHb41uP$jBd9NcfyNWtwHJAIZCIZXNHHJnl30PCwrUS9UL5Z7ErmH022MKXYvYPafZQAvjZ7qGxND9yAKVmo2KhGxbeto0	{1,2}	XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	\N	{"active_at": "2021-11-03T08:26:18Z"}
\.


--
-- Data for Name: visualizations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.visualizations (updated_at, created_at, id, type, query_id, name, description, options) FROM stdin;
2021-11-03 08:26:05.665869+00	2021-11-03 08:26:05.665869+00	1	TABLE	1	Table		{}
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

SELECT pg_catalog.setval('public.changes_id_seq', 1, true);


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

SELECT pg_catalog.setval('public.events_id_seq', 48, true);


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

SELECT pg_catalog.setval('public.queries_id_seq', 1, true);


--
-- Name: query_results_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.query_results_id_seq', 2, true);


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

SELECT pg_catalog.setval('public.visualizations_id_seq', 1, true);


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

CREATE TRIGGER queries_search_vector_trigger BEFORE INSERT OR UPDATE ON public.queries FOR EACH ROW EXECUTE PROCEDURE public.queries_search_vector_update();


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
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

