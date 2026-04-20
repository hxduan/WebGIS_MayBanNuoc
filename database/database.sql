--
-- PostgreSQL database dump
--

\restrict FUbImmHr5nCq8jQqkBFfULg1URrcNRJeFTRDN0Bdd6cYx2eBixwHSPS6L9ecdYK

-- Dumped from database version 15.15
-- Dumped by pg_dump version 15.15

-- Started on 2026-04-12 23:16:50

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 221 (class 1259 OID 39678)
-- Name: logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.logs (
    id integer NOT NULL,
    machine_id integer,
    action character varying(100),
    note text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.logs OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 39677)
-- Name: logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.logs_id_seq OWNER TO postgres;

--
-- TOC entry 3379 (class 0 OID 0)
-- Dependencies: 220
-- Name: logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.logs_id_seq OWNED BY public.logs.id;


--
-- TOC entry 215 (class 1259 OID 39634)
-- Name: machines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.machines (
    id integer NOT NULL,
    name character varying(255),
    type character varying(100),
    status character varying(50),
    lat double precision,
    lng double precision,
    image text,
    area_type character varying(100),
    last_refill timestamp without time zone,
    last_maintenance timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.machines OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 39633)
-- Name: machines_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.machines_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.machines_id_seq OWNER TO postgres;

--
-- TOC entry 3380 (class 0 OID 0)
-- Dependencies: 214
-- Name: machines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.machines_id_seq OWNED BY public.machines.id;


--
-- TOC entry 217 (class 1259 OID 39644)
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    id integer NOT NULL,
    machine_id integer,
    name character varying(255),
    price integer,
    stock integer,
    max_stock integer DEFAULT 50,
    image text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    max_slot integer DEFAULT 50
);


ALTER TABLE public.products OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 39643)
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.products_id_seq OWNER TO postgres;

--
-- TOC entry 3381 (class 0 OID 0)
-- Dependencies: 216
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- TOC entry 219 (class 1259 OID 39660)
-- Name: sales; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales (
    id integer NOT NULL,
    product_id integer,
    quantity integer,
    total integer,
    machine_id integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.sales OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 39659)
-- Name: sales_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sales_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sales_id_seq OWNER TO postgres;

--
-- TOC entry 3382 (class 0 OID 0)
-- Dependencies: 218
-- Name: sales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sales_id_seq OWNED BY public.sales.id;


--
-- TOC entry 223 (class 1259 OID 39693)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(100),
    password character varying(255),
    role character varying(50) DEFAULT 'admin'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 39692)
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
-- TOC entry 3383 (class 0 OID 0)
-- Dependencies: 222
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 3201 (class 2604 OID 39681)
-- Name: logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs ALTER COLUMN id SET DEFAULT nextval('public.logs_id_seq'::regclass);


--
-- TOC entry 3193 (class 2604 OID 39637)
-- Name: machines id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.machines ALTER COLUMN id SET DEFAULT nextval('public.machines_id_seq'::regclass);


--
-- TOC entry 3195 (class 2604 OID 39647)
-- Name: products id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- TOC entry 3199 (class 2604 OID 39663)
-- Name: sales id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales ALTER COLUMN id SET DEFAULT nextval('public.sales_id_seq'::regclass);


--
-- TOC entry 3203 (class 2604 OID 39696)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3371 (class 0 OID 39678)
-- Dependencies: 221
-- Data for Name: logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.logs (id, machine_id, action, note, created_at) FROM stdin;
1	32	error	Máy lỗi	2026-03-26 18:00:52.482243
2	32	error	Máy lỗi	2026-03-26 18:00:53.498959
3	32	fix	Đã sửa	2026-03-26 18:00:55.620855
4	32	error	Máy lỗi	2026-03-26 18:00:59.513922
5	32	fix	Đã sửa	2026-03-26 18:01:12.934346
6	1	report	Báo cáo bán hàng	2026-03-26 21:01:54.691734
7	1	report	Báo cáo bán hàng	2026-03-26 21:05:00.174906
8	1	report	Báo cáo bán hàng	2026-03-26 21:12:13.64623
9	1	report	Báo cáo bán hàng	2026-03-26 21:17:05.020049
10	1	report	Báo cáo bán hàng	2026-03-26 21:28:49.518563
11	1	report	Báo cáo bán hàng	2026-03-26 21:29:38.784119
12	1	report	Báo cáo bán hàng	2026-03-26 21:29:49.320533
13	1	report	Báo cáo bán hàng	2026-03-26 21:30:20.815032
14	1	report	Báo cáo bán hàng	2026-03-26 21:30:32.0275
15	1	report	Báo cáo bán hàng	2026-03-26 21:30:41.838574
16	1	report	Báo cáo bán hàng	2026-03-26 21:31:01.685601
17	1	report	Báo cáo bán hàng	2026-03-26 21:34:29.220276
18	1	refill	Tiếp hàng toàn bộ máy	2026-03-26 21:57:13.885363
19	1	report	Báo cáo bán hàng	2026-03-26 22:06:35.552323
20	1	refill	Tiếp hàng	2026-03-26 22:06:40.88021
21	1	refill	Tiếp hàng	2026-03-26 22:06:42.830471
22	1	refill	Tiếp hàng	2026-03-26 22:06:43.944272
23	1	refill	Tiếp hàng	2026-03-26 22:06:54.577653
24	5	report	Báo cáo bán hàng	2026-03-27 01:52:32.461997
25	9	report	Báo cáo bán hàng	2026-03-27 01:53:50.319692
26	9	error	Máy lỗi	2026-03-27 01:55:50.667045
27	9	error	Máy lỗi	2026-03-27 01:55:51.630488
28	9	fix	Đã sửa	2026-03-27 01:55:52.875117
29	9	report	Báo cáo bán hàng	2026-03-27 01:55:59.76426
30	9	report	Báo cáo bán hàng	2026-03-27 01:56:19.079806
31	9	report	Báo cáo bán hàng	2026-03-27 01:56:35.936713
32	5	report	Báo cáo bán hàng	2026-03-27 02:02:03.171017
33	13	report	Báo cáo bán hàng	2026-03-27 02:02:49.781516
34	5	report	Báo cáo bán hàng	2026-03-27 02:03:41.498808
35	5	report	Báo cáo bán hàng	2026-03-27 02:04:04.521789
36	5	refill	Tiếp hàng	2026-03-27 02:04:12.168487
37	4	error	Máy lỗi	2026-03-27 02:45:06.584441
38	4	fix	Đã sửa	2026-03-27 02:45:11.719975
39	44	refill	Tiếp hàng	2026-03-29 14:26:50.494233
\.


--
-- TOC entry 3365 (class 0 OID 39634)
-- Dependencies: 215
-- Data for Name: machines; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.machines (id, name, type, status, lat, lng, image, area_type, last_refill, last_maintenance, created_at) FROM stdin;
1	Cafe Hồ Gươm	Cafe	Hoạt động	21.0285	105.8542	/uploads/machines/machine_1.png	Trung tâm	2026-03-26 22:06:54.576753	\N	2026-03-26 17:54:09.005263
2	Trà sữa Tràng Tiền	Trà sữa	Hoạt động	21.028971209721316	105.85128664970398	/uploads/machines/machine_2.png	Trung tâm	\N	\N	2026-03-26 17:54:09.005263
5	Cafe Bách Khoa	Cafe	Hoạt động	21.004	105.843	/uploads/machines/machine_5.png	Sinh viên	2026-03-27 02:04:12.165542	\N	2026-03-26 17:54:09.005263
9	Cafe Royal City	Cafe	Hoạt động	20.998	105.815	/uploads/machines/machine_9.png	TTTM	\N	2026-03-27 01:55:52.872091	2026-03-26 17:54:09.005263
13	Cafe Keangnam	Cafe	Hoạt động	21.016	105.783	/uploads/machines/machine_13.png	Văn phòng	\N	\N	2026-03-26 17:54:09.005263
17	Cafe Hà Đông	Cafe	Hoạt động	20.97	105.77	/uploads/machines/machine_17.png	Khu dân cư	\N	\N	2026-03-26 17:54:09.005263
21	Cafe Long Biên	Cafe	Hoạt động	21.045	105.89	/uploads/machines/machine_21.png	Khu dân cư	\N	\N	2026-03-26 17:54:09.005263
25	Cafe Nguyễn Xiển	Cafe	Hoạt động	20.99	105.8	/uploads/machines/machine_25.png	Sinh viên	\N	\N	2026-03-26 17:54:09.005263
29	Cafe Định Công	Cafe	Hoạt động	20.98	105.83	/uploads/machines/machine_29.png	Sinh viên	\N	\N	2026-03-26 17:54:09.005263
32	Giải khát Yên Sở	Giải khát	Hoạt động	20.96	105.87	/uploads/machines/machine_32.png	Công viên	\N	2026-03-26 18:01:12.930396	2026-03-26 17:54:09.005263
33	Cafe Bắc Từ Liêm	Cafe	Hoạt động	21.06	105.74	/uploads/machines/machine_33.png	Sinh viên	\N	\N	2026-03-26 17:54:09.005263
37	Cafe Nam Từ Liêm	Cafe	Hoạt động	21.02	105.76	/uploads/machines/machine_37.png	Văn phòng	\N	\N	2026-03-26 17:54:09.005263
40	Giải khát Mễ Trì	Giải khát	Hoạt động	21.02	105.79	/uploads/machines/machine_40.png	Văn phòng	\N	\N	2026-03-26 17:54:09.005263
44	Giải khát Đống Đa	Giải khát	Hoạt động	21.018	105.83	/uploads/machines/machine_44.png	Trung tâm	2026-03-29 14:26:50.489914	\N	2026-03-26 17:54:09.005263
48	Giải khát Nguyễn Du	Giải khát	Hoạt động	21.02	105.84	/uploads/machines/machine_48.png	Trung tâm	\N	\N	2026-03-26 17:54:09.005263
45	Cafe Hai Bà Trưng	Cafe	Hoạt động	21.01	105.85	/uploads/machines/machine_45.png	Trung tâm	\N	\N	2026-03-26 17:54:09.005263
49	Cafe Láng Hạ	Cafe	Hoạt động	21.022	105.81	/uploads/machines/machine_49.png	Văn phòng	\N	\N	2026-03-26 17:54:09.005263
10	Trà sữa Cầu Giấy	Trà sữa	Hoạt động	21.036	105.79	/uploads/machines/machine_10.png	Văn phòng	\N	\N	2026-03-26 17:54:09.005263
14	Trà sữa Hồ Tây	Trà sữa	Hoạt động	21.064	105.824	/uploads/machines/machine_14.png	Du lịch	\N	\N	2026-03-26 17:54:09.005263
18	Trà sữa Văn Quán	Trà sữa	Hoạt động	20.978	105.79	/uploads/machines/machine_18.png	Sinh viên	\N	\N	2026-03-26 17:54:09.005263
22	Trà sữa Sài Đồng	Trà sữa	Hoạt động	21.041	105.897	/uploads/machines/machine_22.png	Khu dân cư	\N	\N	2026-03-26 17:54:09.005263
26	Trà sữa Linh Đàm	Trà sữa	Hoạt động	20.965	105.82	/uploads/machines/machine_26.png	Khu dân cư	\N	\N	2026-03-26 17:54:09.005263
30	Trà sữa Giáp Bát	Trà sữa	Hoạt động	20.98	105.84	/uploads/machines/machine_30.png	Bến xe	\N	\N	2026-03-26 17:54:09.005263
34	Trà sữa Cổ Nhuế	Trà sữa	Hoạt động	21.055	105.76	/uploads/machines/machine_34.png	Sinh viên	\N	\N	2026-03-26 17:54:09.005263
38	Trà sữa Mỹ Đình	Trà sữa	Hoạt động	21.03	105.77	/uploads/machines/machine_38.png	Sinh viên	\N	\N	2026-03-26 17:54:09.005263
41	Cafe Trung Văn	Cafe	Hoạt động	21.01	105.78	/uploads/machines/machine_41.png	Khu dân cư	\N	\N	2026-03-26 17:54:09.005263
42	Trà sữa Kim Mã	Trà sữa	Hoạt động	21.03	105.82	/uploads/machines/machine_42.png	Trung tâm	\N	\N	2026-03-26 17:54:09.005263
3	Nước ép Nhà Thờ	Nước ép	Hoạt động	21.0295	105.848	/uploads/machines/machine_3.png	Du lịch	\N	\N	2026-03-26 17:54:09.005263
4	Giải khát Bờ Hồ	Giải khát	Hoạt động	21.027	105.855	/uploads/machines/machine_4.png	Du lịch	\N	2026-03-27 02:45:11.716788	2026-03-26 17:54:09.005263
6	Trà sữa Bạch Mai	Trà sữa	Hoạt động	21.003	105.842	/uploads/machines/machine_6.png	Sinh viên	\N	\N	2026-03-26 17:54:09.005263
7	Nước ép Times City	Nước ép	Hoạt động	20.996	105.868	/uploads/machines/machine_7.png	TTTM	\N	\N	2026-03-26 17:54:09.005263
8	Giải khát Vincom	Giải khát	Hoạt động	21.012	105.85	/uploads/machines/machine_8.png	TTTM	\N	\N	2026-03-26 17:54:09.005263
11	Nước ép Duy Tân	Nước ép	Hoạt động	21.035	105.785	/uploads/machines/machine_11.png	Văn phòng	\N	\N	2026-03-26 17:54:09.005263
12	Giải khát Mỹ Đình	Giải khát	Hoạt động	21.028	105.77	/uploads/machines/machine_12.png	Sân vận động	\N	\N	2026-03-26 17:54:09.005263
15	Nước ép Tây Hồ	Nước ép	Hoạt động	21.067	105.82	/uploads/machines/machine_15.png	Du lịch	\N	\N	2026-03-26 17:54:09.005263
16	Giải khát Nhật Tân	Giải khát	Hoạt động	21.075	105.82	/uploads/machines/machine_16.png	Du lịch	\N	\N	2026-03-26 17:54:09.005263
36	Giải khát Đông Ngạc	Giải khát	Hoạt động	21.07	105.74	/uploads/machines/machine_36.png	Khu dân cư	\N	\N	2026-03-26 17:54:09.005263
39	Nước ép Phú Đô	Nước ép	Hoạt động	21.028	105.77	/uploads/machines/machine_39.png	Khu dân cư	\N	\N	2026-03-26 17:54:09.005263
43	Nước ép Ba Đình	Nước ép	Hoạt động	21.035	105.82	/uploads/machines/machine_43.png	Trung tâm	\N	\N	2026-03-26 17:54:09.005263
19	Nước ép Mỗ Lao	Nước ép	Hoạt động	20.983	105.785	/uploads/machines/machine_19.png	Sinh viên	\N	\N	2026-03-26 17:54:09.005263
20	Giải khát Aeon	Giải khát	Hoạt động	20.98	105.76	/uploads/machines/machine_20.png	TTTM	\N	\N	2026-03-26 17:54:09.005263
23	Nước ép Đức Giang	Nước ép	Hoạt động	21.055	105.91	/uploads/machines/machine_23.png	Khu dân cư	\N	\N	2026-03-26 17:54:09.005263
24	Giải khát Thanh Xuân	Giải khát	Hoạt động	20.995	105.81	/uploads/machines/machine_24.png	Khu dân cư	\N	\N	2026-03-26 17:54:09.005263
27	Nước ép Lê Văn Lương	Nước ép	Hoạt động	21.01	105.79	/uploads/machines/machine_27.png	Văn phòng	\N	\N	2026-03-26 17:54:09.005263
28	Giải khát Hoàng Mai	Giải khát	Hoạt động	20.97	105.86	/uploads/machines/machine_28.png	Khu dân cư	\N	\N	2026-03-26 17:54:09.005263
31	Nước ép Tam Trinh	Nước ép	Hoạt động	20.97	105.85	/uploads/machines/machine_31.png	Khu dân cư	\N	\N	2026-03-26 17:54:09.005263
35	Nước ép Xuân Đỉnh	Nước ép	Hoạt động	21.07	105.76	/uploads/machines/machine_35.png	Khu dân cư	\N	\N	2026-03-26 17:54:09.005263
46	Trà sữa Hoàn Kiếm	Trà sữa	Hoạt động	21.028	105.85	/uploads/machines/machine_46.png	Trung tâm	\N	\N	2026-03-26 17:54:09.005263
47	Nước ép Phố Huế	Nước ép	Hoạt động	21.015	105.85	/uploads/machines/machine_47.png	Trung tâm	\N	\N	2026-03-26 17:54:09.005263
50	Trà sữa Giảng Võ	Trà sữa	Hoạt động	21.025	105.815	/uploads/machines/machine_50.png	Văn phòng	\N	\N	2026-03-26 17:54:09.005263
\.


--
-- TOC entry 3367 (class 0 OID 39644)
-- Dependencies: 217
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (id, machine_id, name, price, stock, max_stock, image, created_at, max_slot) FROM stdin;
5	17	Cafe đen	20000	20	50	/uploads/products/capheden.png	2026-03-26 17:59:27.329634	50
6	21	Cafe đen	20000	20	50	/uploads/products/capheden.png	2026-03-26 17:59:27.329634	50
7	25	Cafe đen	20000	20	50	/uploads/products/capheden.png	2026-03-26 17:59:27.329634	50
8	29	Cafe đen	20000	20	50	/uploads/products/capheden.png	2026-03-26 17:59:27.329634	50
9	33	Cafe đen	20000	20	50	/uploads/products/capheden.png	2026-03-26 17:59:27.329634	50
10	37	Cafe đen	20000	20	50	/uploads/products/capheden.png	2026-03-26 17:59:27.329634	50
11	41	Cafe đen	20000	20	50	/uploads/products/capheden.png	2026-03-26 17:59:27.329634	50
12	45	Cafe đen	20000	20	50	/uploads/products/capheden.png	2026-03-26 17:59:27.329634	50
13	49	Cafe đen	20000	20	50	/uploads/products/capheden.png	2026-03-26 17:59:27.329634	50
18	17	Cafe sữa	22000	20	50	/uploads/products/caphesua.png	2026-03-26 17:59:27.329634	50
19	21	Cafe sữa	22000	20	50	/uploads/products/caphesua.png	2026-03-26 17:59:27.329634	50
20	25	Cafe sữa	22000	20	50	/uploads/products/caphesua.png	2026-03-26 17:59:27.329634	50
21	29	Cafe sữa	22000	20	50	/uploads/products/caphesua.png	2026-03-26 17:59:27.329634	50
22	33	Cafe sữa	22000	20	50	/uploads/products/caphesua.png	2026-03-26 17:59:27.329634	50
23	37	Cafe sữa	22000	20	50	/uploads/products/caphesua.png	2026-03-26 17:59:27.329634	50
24	41	Cafe sữa	22000	20	50	/uploads/products/caphesua.png	2026-03-26 17:59:27.329634	50
25	45	Cafe sữa	22000	20	50	/uploads/products/caphesua.png	2026-03-26 17:59:27.329634	50
26	49	Cafe sữa	22000	20	50	/uploads/products/caphesua.png	2026-03-26 17:59:27.329634	50
29	9	Bạc xỉu	25000	20	50	/uploads/products/bacxiu.png	2026-03-26 17:59:27.329634	50
31	17	Bạc xỉu	25000	20	50	/uploads/products/bacxiu.png	2026-03-26 17:59:27.329634	50
32	21	Bạc xỉu	25000	20	50	/uploads/products/bacxiu.png	2026-03-26 17:59:27.329634	50
33	25	Bạc xỉu	25000	20	50	/uploads/products/bacxiu.png	2026-03-26 17:59:27.329634	50
34	29	Bạc xỉu	25000	20	50	/uploads/products/bacxiu.png	2026-03-26 17:59:27.329634	50
35	33	Bạc xỉu	25000	20	50	/uploads/products/bacxiu.png	2026-03-26 17:59:27.329634	50
36	37	Bạc xỉu	25000	20	50	/uploads/products/bacxiu.png	2026-03-26 17:59:27.329634	50
37	41	Bạc xỉu	25000	20	50	/uploads/products/bacxiu.png	2026-03-26 17:59:27.329634	50
38	45	Bạc xỉu	25000	20	50	/uploads/products/bacxiu.png	2026-03-26 17:59:27.329634	50
39	49	Bạc xỉu	25000	20	50	/uploads/products/bacxiu.png	2026-03-26 17:59:27.329634	50
42	9	Capuchino	28000	20	50	/uploads/products/capuchino.png	2026-03-26 17:59:27.329634	50
44	17	Capuchino	28000	20	50	/uploads/products/capuchino.png	2026-03-26 17:59:27.329634	50
45	21	Capuchino	28000	20	50	/uploads/products/capuchino.png	2026-03-26 17:59:27.329634	50
46	25	Capuchino	28000	20	50	/uploads/products/capuchino.png	2026-03-26 17:59:27.329634	50
47	29	Capuchino	28000	20	50	/uploads/products/capuchino.png	2026-03-26 17:59:27.329634	50
48	33	Capuchino	28000	20	50	/uploads/products/capuchino.png	2026-03-26 17:59:27.329634	50
49	37	Capuchino	28000	20	50	/uploads/products/capuchino.png	2026-03-26 17:59:27.329634	50
50	41	Capuchino	28000	20	50	/uploads/products/capuchino.png	2026-03-26 17:59:27.329634	50
51	45	Capuchino	28000	20	50	/uploads/products/capuchino.png	2026-03-26 17:59:27.329634	50
52	49	Capuchino	28000	20	50	/uploads/products/capuchino.png	2026-03-26 17:59:27.329634	50
55	9	Latte	30000	20	50	/uploads/products/latte.png	2026-03-26 17:59:27.329634	50
56	13	Latte	30000	20	50	/uploads/products/latte.png	2026-03-26 17:59:27.329634	50
57	17	Latte	30000	20	50	/uploads/products/latte.png	2026-03-26 17:59:27.329634	50
58	21	Latte	30000	20	50	/uploads/products/latte.png	2026-03-26 17:59:27.329634	50
59	25	Latte	30000	20	50	/uploads/products/latte.png	2026-03-26 17:59:27.329634	50
60	29	Latte	30000	20	50	/uploads/products/latte.png	2026-03-26 17:59:27.329634	50
61	33	Latte	30000	20	50	/uploads/products/latte.png	2026-03-26 17:59:27.329634	50
62	37	Latte	30000	20	50	/uploads/products/latte.png	2026-03-26 17:59:27.329634	50
63	41	Latte	30000	20	50	/uploads/products/latte.png	2026-03-26 17:59:27.329634	50
64	45	Latte	30000	20	50	/uploads/products/latte.png	2026-03-26 17:59:27.329634	50
65	49	Latte	30000	20	50	/uploads/products/latte.png	2026-03-26 17:59:27.329634	50
66	2	Trà sữa dâu tây	25000	20	50	/uploads/products/trasuadautay.png	2026-03-26 17:59:56.59039	50
67	10	Trà sữa dâu tây	25000	20	50	/uploads/products/trasuadautay.png	2026-03-26 17:59:56.59039	50
68	14	Trà sữa dâu tây	25000	20	50	/uploads/products/trasuadautay.png	2026-03-26 17:59:56.59039	50
69	18	Trà sữa dâu tây	25000	20	50	/uploads/products/trasuadautay.png	2026-03-26 17:59:56.59039	50
70	22	Trà sữa dâu tây	25000	20	50	/uploads/products/trasuadautay.png	2026-03-26 17:59:56.59039	50
71	26	Trà sữa dâu tây	25000	20	50	/uploads/products/trasuadautay.png	2026-03-26 17:59:56.59039	50
72	30	Trà sữa dâu tây	25000	20	50	/uploads/products/trasuadautay.png	2026-03-26 17:59:56.59039	50
73	34	Trà sữa dâu tây	25000	20	50	/uploads/products/trasuadautay.png	2026-03-26 17:59:56.59039	50
74	38	Trà sữa dâu tây	25000	20	50	/uploads/products/trasuadautay.png	2026-03-26 17:59:56.59039	50
75	42	Trà sữa dâu tây	25000	20	50	/uploads/products/trasuadautay.png	2026-03-26 17:59:56.59039	50
76	46	Trà sữa dâu tây	25000	20	50	/uploads/products/trasuadautay.png	2026-03-26 17:59:56.59039	50
77	50	Trà sữa dâu tây	25000	20	50	/uploads/products/trasuadautay.png	2026-03-26 17:59:56.59039	50
78	6	Trà sữa dâu tây	25000	20	50	/uploads/products/trasuadautay.png	2026-03-26 17:59:56.59039	50
79	2	Trà sữa khoai môn	25000	20	50	/uploads/products/trasuakhoaimon.png	2026-03-26 17:59:56.59039	50
80	10	Trà sữa khoai môn	25000	20	50	/uploads/products/trasuakhoaimon.png	2026-03-26 17:59:56.59039	50
40	1	Capuchino	28000	48	50	/uploads/products/capuchino.png	2026-03-26 17:59:27.329634	50
17	13	Cafe sữa	22000	19	50	/uploads/products/caphesua.png	2026-03-26 17:59:27.329634	50
3	9	Cafe đen	20000	9	50	/uploads/products/capheden.png	2026-03-26 17:59:27.329634	50
16	9	Cafe sữa	22000	8	50	/uploads/products/caphesua.png	2026-03-26 17:59:27.329634	50
30	13	Bạc xỉu	25000	19	50	/uploads/products/bacxiu.png	2026-03-26 17:59:27.329634	50
4	13	Cafe đen	20000	10	50	/uploads/products/capheden.png	2026-03-26 17:59:27.329634	50
43	13	Capuchino	28000	11	50	/uploads/products/capuchino.png	2026-03-26 17:59:27.329634	50
54	5	Latte	30000	50	50	/uploads/products/latte.png	2026-03-26 17:59:27.329634	50
2	5	Cafe đen	20000	50	50	/uploads/products/capheden.png	2026-03-26 17:59:27.329634	50
81	14	Trà sữa khoai môn	25000	20	50	/uploads/products/trasuakhoaimon.png	2026-03-26 17:59:56.59039	50
82	18	Trà sữa khoai môn	25000	20	50	/uploads/products/trasuakhoaimon.png	2026-03-26 17:59:56.59039	50
83	22	Trà sữa khoai môn	25000	20	50	/uploads/products/trasuakhoaimon.png	2026-03-26 17:59:56.59039	50
84	26	Trà sữa khoai môn	25000	20	50	/uploads/products/trasuakhoaimon.png	2026-03-26 17:59:56.59039	50
85	30	Trà sữa khoai môn	25000	20	50	/uploads/products/trasuakhoaimon.png	2026-03-26 17:59:56.59039	50
86	34	Trà sữa khoai môn	25000	20	50	/uploads/products/trasuakhoaimon.png	2026-03-26 17:59:56.59039	50
87	38	Trà sữa khoai môn	25000	20	50	/uploads/products/trasuakhoaimon.png	2026-03-26 17:59:56.59039	50
88	42	Trà sữa khoai môn	25000	20	50	/uploads/products/trasuakhoaimon.png	2026-03-26 17:59:56.59039	50
89	46	Trà sữa khoai môn	25000	20	50	/uploads/products/trasuakhoaimon.png	2026-03-26 17:59:56.59039	50
90	50	Trà sữa khoai môn	25000	20	50	/uploads/products/trasuakhoaimon.png	2026-03-26 17:59:56.59039	50
91	6	Trà sữa khoai môn	25000	20	50	/uploads/products/trasuakhoaimon.png	2026-03-26 17:59:56.59039	50
92	2	Trà sữa phô mai	27000	20	50	/uploads/products/trasuaphomai.png	2026-03-26 17:59:56.59039	50
93	10	Trà sữa phô mai	27000	20	50	/uploads/products/trasuaphomai.png	2026-03-26 17:59:56.59039	50
94	14	Trà sữa phô mai	27000	20	50	/uploads/products/trasuaphomai.png	2026-03-26 17:59:56.59039	50
95	18	Trà sữa phô mai	27000	20	50	/uploads/products/trasuaphomai.png	2026-03-26 17:59:56.59039	50
96	22	Trà sữa phô mai	27000	20	50	/uploads/products/trasuaphomai.png	2026-03-26 17:59:56.59039	50
97	26	Trà sữa phô mai	27000	20	50	/uploads/products/trasuaphomai.png	2026-03-26 17:59:56.59039	50
98	30	Trà sữa phô mai	27000	20	50	/uploads/products/trasuaphomai.png	2026-03-26 17:59:56.59039	50
99	34	Trà sữa phô mai	27000	20	50	/uploads/products/trasuaphomai.png	2026-03-26 17:59:56.59039	50
100	38	Trà sữa phô mai	27000	20	50	/uploads/products/trasuaphomai.png	2026-03-26 17:59:56.59039	50
101	42	Trà sữa phô mai	27000	20	50	/uploads/products/trasuaphomai.png	2026-03-26 17:59:56.59039	50
102	46	Trà sữa phô mai	27000	20	50	/uploads/products/trasuaphomai.png	2026-03-26 17:59:56.59039	50
103	50	Trà sữa phô mai	27000	20	50	/uploads/products/trasuaphomai.png	2026-03-26 17:59:56.59039	50
104	6	Trà sữa phô mai	27000	20	50	/uploads/products/trasuaphomai.png	2026-03-26 17:59:56.59039	50
105	2	Trà sữa trân châu	27000	20	50	/uploads/products/trasuatranchauduongden.png	2026-03-26 17:59:56.59039	50
106	10	Trà sữa trân châu	27000	20	50	/uploads/products/trasuatranchauduongden.png	2026-03-26 17:59:56.59039	50
107	14	Trà sữa trân châu	27000	20	50	/uploads/products/trasuatranchauduongden.png	2026-03-26 17:59:56.59039	50
108	18	Trà sữa trân châu	27000	20	50	/uploads/products/trasuatranchauduongden.png	2026-03-26 17:59:56.59039	50
109	22	Trà sữa trân châu	27000	20	50	/uploads/products/trasuatranchauduongden.png	2026-03-26 17:59:56.59039	50
110	26	Trà sữa trân châu	27000	20	50	/uploads/products/trasuatranchauduongden.png	2026-03-26 17:59:56.59039	50
111	30	Trà sữa trân châu	27000	20	50	/uploads/products/trasuatranchauduongden.png	2026-03-26 17:59:56.59039	50
112	34	Trà sữa trân châu	27000	20	50	/uploads/products/trasuatranchauduongden.png	2026-03-26 17:59:56.59039	50
113	38	Trà sữa trân châu	27000	20	50	/uploads/products/trasuatranchauduongden.png	2026-03-26 17:59:56.59039	50
114	42	Trà sữa trân châu	27000	20	50	/uploads/products/trasuatranchauduongden.png	2026-03-26 17:59:56.59039	50
115	46	Trà sữa trân châu	27000	20	50	/uploads/products/trasuatranchauduongden.png	2026-03-26 17:59:56.59039	50
116	50	Trà sữa trân châu	27000	20	50	/uploads/products/trasuatranchauduongden.png	2026-03-26 17:59:56.59039	50
117	6	Trà sữa trân châu	27000	20	50	/uploads/products/trasuatranchauduongden.png	2026-03-26 17:59:56.59039	50
118	2	Matcha Latte	28000	20	50	/uploads/products/matchalatte.png	2026-03-26 17:59:56.59039	50
119	10	Matcha Latte	28000	20	50	/uploads/products/matchalatte.png	2026-03-26 17:59:56.59039	50
120	14	Matcha Latte	28000	20	50	/uploads/products/matchalatte.png	2026-03-26 17:59:56.59039	50
121	18	Matcha Latte	28000	20	50	/uploads/products/matchalatte.png	2026-03-26 17:59:56.59039	50
122	22	Matcha Latte	28000	20	50	/uploads/products/matchalatte.png	2026-03-26 17:59:56.59039	50
123	26	Matcha Latte	28000	20	50	/uploads/products/matchalatte.png	2026-03-26 17:59:56.59039	50
124	30	Matcha Latte	28000	20	50	/uploads/products/matchalatte.png	2026-03-26 17:59:56.59039	50
125	34	Matcha Latte	28000	20	50	/uploads/products/matchalatte.png	2026-03-26 17:59:56.59039	50
126	38	Matcha Latte	28000	20	50	/uploads/products/matchalatte.png	2026-03-26 17:59:56.59039	50
127	42	Matcha Latte	28000	20	50	/uploads/products/matchalatte.png	2026-03-26 17:59:56.59039	50
128	46	Matcha Latte	28000	20	50	/uploads/products/matchalatte.png	2026-03-26 17:59:56.59039	50
129	50	Matcha Latte	28000	20	50	/uploads/products/matchalatte.png	2026-03-26 17:59:56.59039	50
130	6	Matcha Latte	28000	20	50	/uploads/products/matchalatte.png	2026-03-26 17:59:56.59039	50
131	3	Nước ép chanh	20000	20	50	/uploads/products/nuocepchanh.png	2026-03-26 18:00:06.063266	50
132	7	Nước ép chanh	20000	20	50	/uploads/products/nuocepchanh.png	2026-03-26 18:00:06.063266	50
133	11	Nước ép chanh	20000	20	50	/uploads/products/nuocepchanh.png	2026-03-26 18:00:06.063266	50
134	15	Nước ép chanh	20000	20	50	/uploads/products/nuocepchanh.png	2026-03-26 18:00:06.063266	50
135	19	Nước ép chanh	20000	20	50	/uploads/products/nuocepchanh.png	2026-03-26 18:00:06.063266	50
136	23	Nước ép chanh	20000	20	50	/uploads/products/nuocepchanh.png	2026-03-26 18:00:06.063266	50
137	27	Nước ép chanh	20000	20	50	/uploads/products/nuocepchanh.png	2026-03-26 18:00:06.063266	50
138	31	Nước ép chanh	20000	20	50	/uploads/products/nuocepchanh.png	2026-03-26 18:00:06.063266	50
139	35	Nước ép chanh	20000	20	50	/uploads/products/nuocepchanh.png	2026-03-26 18:00:06.063266	50
140	39	Nước ép chanh	20000	20	50	/uploads/products/nuocepchanh.png	2026-03-26 18:00:06.063266	50
141	43	Nước ép chanh	20000	20	50	/uploads/products/nuocepchanh.png	2026-03-26 18:00:06.063266	50
142	47	Nước ép chanh	20000	20	50	/uploads/products/nuocepchanh.png	2026-03-26 18:00:06.063266	50
143	3	Nước ép cherry	22000	20	50	/uploads/products/nuocepcherry.png	2026-03-26 18:00:06.063266	50
144	7	Nước ép cherry	22000	20	50	/uploads/products/nuocepcherry.png	2026-03-26 18:00:06.063266	50
145	11	Nước ép cherry	22000	20	50	/uploads/products/nuocepcherry.png	2026-03-26 18:00:06.063266	50
146	15	Nước ép cherry	22000	20	50	/uploads/products/nuocepcherry.png	2026-03-26 18:00:06.063266	50
147	19	Nước ép cherry	22000	20	50	/uploads/products/nuocepcherry.png	2026-03-26 18:00:06.063266	50
148	23	Nước ép cherry	22000	20	50	/uploads/products/nuocepcherry.png	2026-03-26 18:00:06.063266	50
149	27	Nước ép cherry	22000	20	50	/uploads/products/nuocepcherry.png	2026-03-26 18:00:06.063266	50
150	31	Nước ép cherry	22000	20	50	/uploads/products/nuocepcherry.png	2026-03-26 18:00:06.063266	50
151	35	Nước ép cherry	22000	20	50	/uploads/products/nuocepcherry.png	2026-03-26 18:00:06.063266	50
152	39	Nước ép cherry	22000	20	50	/uploads/products/nuocepcherry.png	2026-03-26 18:00:06.063266	50
153	43	Nước ép cherry	22000	20	50	/uploads/products/nuocepcherry.png	2026-03-26 18:00:06.063266	50
154	47	Nước ép cherry	22000	20	50	/uploads/products/nuocepcherry.png	2026-03-26 18:00:06.063266	50
155	3	Nước ép chuối	22000	20	50	/uploads/products/nuocepchuoi.png	2026-03-26 18:00:06.063266	50
156	7	Nước ép chuối	22000	20	50	/uploads/products/nuocepchuoi.png	2026-03-26 18:00:06.063266	50
157	11	Nước ép chuối	22000	20	50	/uploads/products/nuocepchuoi.png	2026-03-26 18:00:06.063266	50
158	15	Nước ép chuối	22000	20	50	/uploads/products/nuocepchuoi.png	2026-03-26 18:00:06.063266	50
159	19	Nước ép chuối	22000	20	50	/uploads/products/nuocepchuoi.png	2026-03-26 18:00:06.063266	50
160	23	Nước ép chuối	22000	20	50	/uploads/products/nuocepchuoi.png	2026-03-26 18:00:06.063266	50
161	27	Nước ép chuối	22000	20	50	/uploads/products/nuocepchuoi.png	2026-03-26 18:00:06.063266	50
162	31	Nước ép chuối	22000	20	50	/uploads/products/nuocepchuoi.png	2026-03-26 18:00:06.063266	50
163	35	Nước ép chuối	22000	20	50	/uploads/products/nuocepchuoi.png	2026-03-26 18:00:06.063266	50
164	39	Nước ép chuối	22000	20	50	/uploads/products/nuocepchuoi.png	2026-03-26 18:00:06.063266	50
165	43	Nước ép chuối	22000	20	50	/uploads/products/nuocepchuoi.png	2026-03-26 18:00:06.063266	50
166	47	Nước ép chuối	22000	20	50	/uploads/products/nuocepchuoi.png	2026-03-26 18:00:06.063266	50
167	3	Nước ép dâu	22000	20	50	/uploads/products/nuocepdau.png	2026-03-26 18:00:06.063266	50
168	7	Nước ép dâu	22000	20	50	/uploads/products/nuocepdau.png	2026-03-26 18:00:06.063266	50
169	11	Nước ép dâu	22000	20	50	/uploads/products/nuocepdau.png	2026-03-26 18:00:06.063266	50
170	15	Nước ép dâu	22000	20	50	/uploads/products/nuocepdau.png	2026-03-26 18:00:06.063266	50
171	19	Nước ép dâu	22000	20	50	/uploads/products/nuocepdau.png	2026-03-26 18:00:06.063266	50
172	23	Nước ép dâu	22000	20	50	/uploads/products/nuocepdau.png	2026-03-26 18:00:06.063266	50
173	27	Nước ép dâu	22000	20	50	/uploads/products/nuocepdau.png	2026-03-26 18:00:06.063266	50
174	31	Nước ép dâu	22000	20	50	/uploads/products/nuocepdau.png	2026-03-26 18:00:06.063266	50
175	35	Nước ép dâu	22000	20	50	/uploads/products/nuocepdau.png	2026-03-26 18:00:06.063266	50
176	39	Nước ép dâu	22000	20	50	/uploads/products/nuocepdau.png	2026-03-26 18:00:06.063266	50
177	43	Nước ép dâu	22000	20	50	/uploads/products/nuocepdau.png	2026-03-26 18:00:06.063266	50
178	47	Nước ép dâu	22000	20	50	/uploads/products/nuocepdau.png	2026-03-26 18:00:06.063266	50
179	3	Nước ép việt quất	25000	20	50	/uploads/products/nuocepvietquat.png	2026-03-26 18:00:06.063266	50
180	7	Nước ép việt quất	25000	20	50	/uploads/products/nuocepvietquat.png	2026-03-26 18:00:06.063266	50
181	11	Nước ép việt quất	25000	20	50	/uploads/products/nuocepvietquat.png	2026-03-26 18:00:06.063266	50
182	15	Nước ép việt quất	25000	20	50	/uploads/products/nuocepvietquat.png	2026-03-26 18:00:06.063266	50
183	19	Nước ép việt quất	25000	20	50	/uploads/products/nuocepvietquat.png	2026-03-26 18:00:06.063266	50
184	23	Nước ép việt quất	25000	20	50	/uploads/products/nuocepvietquat.png	2026-03-26 18:00:06.063266	50
185	27	Nước ép việt quất	25000	20	50	/uploads/products/nuocepvietquat.png	2026-03-26 18:00:06.063266	50
186	31	Nước ép việt quất	25000	20	50	/uploads/products/nuocepvietquat.png	2026-03-26 18:00:06.063266	50
187	35	Nước ép việt quất	25000	20	50	/uploads/products/nuocepvietquat.png	2026-03-26 18:00:06.063266	50
188	39	Nước ép việt quất	25000	20	50	/uploads/products/nuocepvietquat.png	2026-03-26 18:00:06.063266	50
189	43	Nước ép việt quất	25000	20	50	/uploads/products/nuocepvietquat.png	2026-03-26 18:00:06.063266	50
190	47	Nước ép việt quất	25000	20	50	/uploads/products/nuocepvietquat.png	2026-03-26 18:00:06.063266	50
191	4	Pepsi	10000	20	50	/uploads/products/pepsi.png	2026-03-26 18:00:16.52951	50
192	8	Pepsi	10000	20	50	/uploads/products/pepsi.png	2026-03-26 18:00:16.52951	50
193	12	Pepsi	10000	20	50	/uploads/products/pepsi.png	2026-03-26 18:00:16.52951	50
194	16	Pepsi	10000	20	50	/uploads/products/pepsi.png	2026-03-26 18:00:16.52951	50
195	20	Pepsi	10000	20	50	/uploads/products/pepsi.png	2026-03-26 18:00:16.52951	50
196	24	Pepsi	10000	20	50	/uploads/products/pepsi.png	2026-03-26 18:00:16.52951	50
197	28	Pepsi	10000	20	50	/uploads/products/pepsi.png	2026-03-26 18:00:16.52951	50
198	32	Pepsi	10000	20	50	/uploads/products/pepsi.png	2026-03-26 18:00:16.52951	50
199	36	Pepsi	10000	20	50	/uploads/products/pepsi.png	2026-03-26 18:00:16.52951	50
200	40	Pepsi	10000	20	50	/uploads/products/pepsi.png	2026-03-26 18:00:16.52951	50
202	48	Pepsi	10000	20	50	/uploads/products/pepsi.png	2026-03-26 18:00:16.52951	50
203	4	Sprite	10000	20	50	/uploads/products/sprite.png	2026-03-26 18:00:16.52951	50
204	8	Sprite	10000	20	50	/uploads/products/sprite.png	2026-03-26 18:00:16.52951	50
205	12	Sprite	10000	20	50	/uploads/products/sprite.png	2026-03-26 18:00:16.52951	50
206	16	Sprite	10000	20	50	/uploads/products/sprite.png	2026-03-26 18:00:16.52951	50
207	20	Sprite	10000	20	50	/uploads/products/sprite.png	2026-03-26 18:00:16.52951	50
208	24	Sprite	10000	20	50	/uploads/products/sprite.png	2026-03-26 18:00:16.52951	50
209	28	Sprite	10000	20	50	/uploads/products/sprite.png	2026-03-26 18:00:16.52951	50
210	32	Sprite	10000	20	50	/uploads/products/sprite.png	2026-03-26 18:00:16.52951	50
211	36	Sprite	10000	20	50	/uploads/products/sprite.png	2026-03-26 18:00:16.52951	50
212	40	Sprite	10000	20	50	/uploads/products/sprite.png	2026-03-26 18:00:16.52951	50
214	48	Sprite	10000	20	50	/uploads/products/sprite.png	2026-03-26 18:00:16.52951	50
215	4	Fanta	10000	20	50	/uploads/products/fanta.png	2026-03-26 18:00:16.52951	50
216	8	Fanta	10000	20	50	/uploads/products/fanta.png	2026-03-26 18:00:16.52951	50
217	12	Fanta	10000	20	50	/uploads/products/fanta.png	2026-03-26 18:00:16.52951	50
218	16	Fanta	10000	20	50	/uploads/products/fanta.png	2026-03-26 18:00:16.52951	50
219	20	Fanta	10000	20	50	/uploads/products/fanta.png	2026-03-26 18:00:16.52951	50
220	24	Fanta	10000	20	50	/uploads/products/fanta.png	2026-03-26 18:00:16.52951	50
221	28	Fanta	10000	20	50	/uploads/products/fanta.png	2026-03-26 18:00:16.52951	50
222	32	Fanta	10000	20	50	/uploads/products/fanta.png	2026-03-26 18:00:16.52951	50
223	36	Fanta	10000	20	50	/uploads/products/fanta.png	2026-03-26 18:00:16.52951	50
224	40	Fanta	10000	20	50	/uploads/products/fanta.png	2026-03-26 18:00:16.52951	50
226	48	Fanta	10000	20	50	/uploads/products/fanta.png	2026-03-26 18:00:16.52951	50
227	4	Lipton	12000	20	50	/uploads/products/lipton.png	2026-03-26 18:00:16.52951	50
228	8	Lipton	12000	20	50	/uploads/products/lipton.png	2026-03-26 18:00:16.52951	50
229	12	Lipton	12000	20	50	/uploads/products/lipton.png	2026-03-26 18:00:16.52951	50
230	16	Lipton	12000	20	50	/uploads/products/lipton.png	2026-03-26 18:00:16.52951	50
231	20	Lipton	12000	20	50	/uploads/products/lipton.png	2026-03-26 18:00:16.52951	50
232	24	Lipton	12000	20	50	/uploads/products/lipton.png	2026-03-26 18:00:16.52951	50
233	28	Lipton	12000	20	50	/uploads/products/lipton.png	2026-03-26 18:00:16.52951	50
234	32	Lipton	12000	20	50	/uploads/products/lipton.png	2026-03-26 18:00:16.52951	50
235	36	Lipton	12000	20	50	/uploads/products/lipton.png	2026-03-26 18:00:16.52951	50
236	40	Lipton	12000	20	50	/uploads/products/lipton.png	2026-03-26 18:00:16.52951	50
238	48	Lipton	12000	20	50	/uploads/products/lipton.png	2026-03-26 18:00:16.52951	50
239	4	Dr Pepper	12000	20	50	/uploads/products/drpepper.png	2026-03-26 18:00:16.52951	50
240	8	Dr Pepper	12000	20	50	/uploads/products/drpepper.png	2026-03-26 18:00:16.52951	50
241	12	Dr Pepper	12000	20	50	/uploads/products/drpepper.png	2026-03-26 18:00:16.52951	50
242	16	Dr Pepper	12000	20	50	/uploads/products/drpepper.png	2026-03-26 18:00:16.52951	50
243	20	Dr Pepper	12000	20	50	/uploads/products/drpepper.png	2026-03-26 18:00:16.52951	50
244	24	Dr Pepper	12000	20	50	/uploads/products/drpepper.png	2026-03-26 18:00:16.52951	50
245	28	Dr Pepper	12000	20	50	/uploads/products/drpepper.png	2026-03-26 18:00:16.52951	50
246	32	Dr Pepper	12000	20	50	/uploads/products/drpepper.png	2026-03-26 18:00:16.52951	50
247	36	Dr Pepper	12000	20	50	/uploads/products/drpepper.png	2026-03-26 18:00:16.52951	50
248	40	Dr Pepper	12000	20	50	/uploads/products/drpepper.png	2026-03-26 18:00:16.52951	50
250	48	Dr Pepper	12000	20	50	/uploads/products/drpepper.png	2026-03-26 18:00:16.52951	50
14	1	Cafe sữa	22000	50	50	/uploads/products/caphesua.png	2026-03-26 17:59:27.329634	50
27	1	Bạc xỉu	25000	50	50	/uploads/products/bacxiu.png	2026-03-26 17:59:27.329634	50
1	1	Cafe đen	20000	50	50	/uploads/products/capheden.png	2026-03-26 17:59:27.329634	50
15	5	Cafe sữa	22000	50	50	/uploads/products/caphesua.png	2026-03-26 17:59:27.329634	50
28	5	Bạc xỉu	25000	50	50	/uploads/products/bacxiu.png	2026-03-26 17:59:27.329634	50
41	5	Capuchino	28000	50	50	/uploads/products/capuchino.png	2026-03-26 17:59:27.329634	50
53	1	Latte	30000	49	50	/uploads/products/latte.png	2026-03-26 17:59:27.329634	50
201	44	Pepsi	10000	50	50	/uploads/products/pepsi.png	2026-03-26 18:00:16.52951	50
213	44	Sprite	10000	50	50	/uploads/products/sprite.png	2026-03-26 18:00:16.52951	50
225	44	Fanta	10000	50	50	/uploads/products/fanta.png	2026-03-26 18:00:16.52951	50
237	44	Lipton	12000	50	50	/uploads/products/lipton.png	2026-03-26 18:00:16.52951	50
249	44	Dr Pepper	12000	50	50	/uploads/products/drpepper.png	2026-03-26 18:00:16.52951	50
\.


--
-- TOC entry 3369 (class 0 OID 39660)
-- Dependencies: 219
-- Data for Name: sales; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sales (id, product_id, quantity, total, machine_id, created_at) FROM stdin;
1	180	1	25000	7	2026-03-26 17:15:18.191083
2	80	1	25000	10	2026-03-26 17:13:10.021349
3	145	1	22000	11	2026-03-26 12:56:43.597542
4	141	1	20000	43	2026-03-26 11:50:54.206688
5	87	1	25000	38	2026-03-26 09:13:43.990562
6	136	1	20000	23	2026-03-26 08:51:51.603948
7	4	1	20000	13	2026-03-26 06:09:57.857571
8	150	1	22000	31	2026-03-25 20:07:24.598394
9	32	1	25000	21	2026-03-25 17:30:42.121802
10	193	1	10000	12	2026-03-25 16:39:24.159165
11	70	1	25000	22	2026-03-25 16:23:36.687858
12	93	1	27000	10	2026-03-25 14:38:38.32323
13	215	1	10000	4	2026-03-25 11:01:05.143961
14	243	1	12000	20	2026-03-25 08:48:40.286692
15	85	1	25000	30	2026-03-25 07:14:28.243469
16	239	1	12000	4	2026-03-25 05:01:44.745026
17	191	1	10000	4	2026-03-25 03:40:15.964744
18	182	1	25000	15	2026-03-24 23:41:39.961336
19	164	1	22000	39	2026-03-24 22:10:59.199268
20	40	1	28000	1	2026-03-24 21:27:53.778234
21	56	1	30000	13	2026-03-24 21:04:55.71372
22	204	1	10000	8	2026-03-24 20:48:20.913402
23	96	1	27000	22	2026-03-24 20:15:11.527143
24	97	1	27000	26	2026-03-24 19:39:33.090104
25	30	1	25000	13	2026-03-24 17:51:38.697522
26	161	1	22000	27	2026-03-24 15:19:12.063125
27	173	1	22000	27	2026-03-24 15:12:17.996829
28	199	1	10000	36	2026-03-24 15:05:22.907174
29	121	1	28000	18	2026-03-24 14:33:18.723775
30	136	1	20000	23	2026-03-24 12:23:06.858548
31	178	1	22000	47	2026-03-24 11:03:00.125234
32	15	1	22000	5	2026-03-24 10:51:12.123125
33	209	1	10000	28	2026-03-24 08:40:28.275538
34	190	1	25000	47	2026-03-24 07:09:14.50561
35	172	1	22000	23	2026-03-24 06:38:41.32343
36	237	1	12000	44	2026-03-24 02:57:36.172895
37	66	1	25000	2	2026-03-24 01:13:59.166914
38	226	1	10000	48	2026-03-24 01:02:04.127517
39	189	1	25000	43	2026-03-23 22:36:56.848303
40	117	1	27000	6	2026-03-23 16:56:54.966454
41	122	1	28000	22	2026-03-23 15:59:56.294491
42	44	1	28000	17	2026-03-23 14:23:02.403282
43	249	1	12000	44	2026-03-23 14:06:44.597303
44	45	1	28000	21	2026-03-23 11:49:37.509757
45	74	1	25000	38	2026-03-23 10:03:23.892619
46	40	1	28000	1	2026-03-23 07:38:43.004772
47	130	1	28000	6	2026-03-23 04:25:19.186142
48	234	1	12000	32	2026-03-23 02:10:14.961012
49	133	1	20000	11	2026-03-22 23:25:59.672832
50	61	1	30000	33	2026-03-22 22:14:23.540367
51	237	1	12000	44	2026-03-22 20:26:29.782468
52	207	1	10000	20	2026-03-22 17:52:21.801541
53	70	1	25000	22	2026-03-22 15:03:33.769272
54	164	1	22000	39	2026-03-22 14:09:17.944508
55	71	1	25000	26	2026-03-22 12:39:09.885873
56	131	1	20000	3	2026-03-22 12:22:36.221003
57	160	1	22000	23	2026-03-22 12:19:12.584971
58	196	1	10000	24	2026-03-22 08:45:07.855887
59	199	1	10000	36	2026-03-22 07:01:36.605437
60	26	1	22000	49	2026-03-22 03:13:01.316827
61	145	1	22000	11	2026-03-22 01:07:16.770034
62	231	1	12000	20	2026-03-21 21:28:45.487692
63	239	1	12000	4	2026-03-21 21:05:55.956041
64	116	1	27000	50	2026-03-21 20:36:37.999871
65	18	1	22000	17	2026-03-21 20:30:15.98684
66	222	1	10000	32	2026-03-21 20:20:54.318941
67	241	1	12000	12	2026-03-21 19:12:43.314249
68	69	1	25000	18	2026-03-21 12:44:15.248589
69	94	1	27000	14	2026-03-21 07:40:15.734173
70	222	1	10000	32	2026-03-21 05:47:49.167518
71	68	1	25000	14	2026-03-21 04:39:30.775751
72	72	1	25000	30	2026-03-21 01:24:57.199304
73	98	1	27000	30	2026-03-20 23:13:35.961141
74	166	1	22000	47	2026-03-20 22:49:31.40538
75	150	1	22000	31	2026-03-20 21:40:56.518187
76	28	1	25000	5	2026-03-20 16:13:08.327197
77	170	1	22000	15	2026-03-20 16:09:51.831109
78	60	1	30000	29	2026-03-20 15:28:10.884782
79	228	1	12000	8	2026-03-20 12:55:18.306993
80	95	1	27000	18	2026-03-20 11:44:07.176972
81	207	1	10000	20	2026-03-20 10:49:34.753786
82	9	1	20000	33	2026-03-20 10:08:29.441163
83	207	1	10000	20	2026-03-20 08:08:27.624243
84	91	1	25000	6	2026-03-20 06:05:49.729164
85	134	1	20000	15	2026-03-20 02:24:14.298016
86	139	1	20000	35	2026-03-20 01:13:47.544512
87	182	1	25000	15	2026-03-20 01:07:05.306927
88	34	1	25000	29	2026-03-20 00:58:48.209911
89	126	1	28000	38	2026-03-20 00:50:22.769956
90	85	1	25000	30	2026-03-19 22:33:40.059829
91	240	1	12000	8	2026-03-19 21:16:53.874262
92	247	1	12000	36	2026-03-19 18:09:46.221577
93	37	1	25000	41	2026-03-19 17:09:29.491026
94	143	1	22000	3	2026-03-19 16:59:52.295964
95	154	1	22000	47	2026-03-19 16:03:21.635784
96	98	1	27000	30	2026-03-19 15:18:36.732332
97	187	1	25000	35	2026-03-19 12:38:45.696953
98	198	1	10000	32	2026-03-19 12:03:09.883655
99	211	1	10000	36	2026-03-19 09:14:15.402077
100	212	1	10000	40	2026-03-19 08:42:57.003164
101	40	1	28000	1	2026-03-19 07:59:42.842417
102	35	1	25000	33	2026-03-19 06:02:59.484172
103	79	1	25000	2	2026-03-19 05:51:52.123508
104	166	1	22000	47	2026-03-19 04:48:24.328716
105	23	1	22000	37	2026-03-19 04:22:31.802053
106	107	1	27000	14	2026-03-19 03:23:37.576554
107	85	1	25000	30	2026-03-18 21:53:32.293633
108	157	1	22000	11	2026-03-18 21:38:10.793094
109	159	1	22000	19	2026-03-18 20:15:07.094674
110	157	1	22000	11	2026-03-18 19:56:48.531836
111	218	1	10000	16	2026-03-18 18:18:01.466386
112	223	1	10000	36	2026-03-18 16:58:40.419113
113	104	1	27000	6	2026-03-18 14:55:27.899064
114	218	1	10000	16	2026-03-18 12:38:40.430526
115	220	1	10000	24	2026-03-18 08:16:52.882191
116	222	1	10000	32	2026-03-18 05:52:36.896601
117	176	1	22000	39	2026-03-18 05:10:12.424472
118	17	1	22000	13	2026-03-18 03:56:45.794217
119	232	1	12000	24	2026-03-18 03:10:57.993684
120	15	1	22000	5	2026-03-18 01:20:01.656225
121	31	1	25000	17	2026-03-18 00:38:08.17983
122	121	1	28000	18	2026-03-17 23:01:52.891053
123	181	1	25000	11	2026-03-17 16:12:05.843001
124	10	1	20000	37	2026-03-17 15:13:52.1907
125	183	1	25000	19	2026-03-17 14:57:33.767237
126	248	1	12000	40	2026-03-17 08:53:58.814341
127	36	1	25000	37	2026-03-17 07:11:10.933097
128	37	1	25000	41	2026-03-17 07:01:34.444471
129	6	1	20000	21	2026-03-17 05:36:41.984599
130	95	1	27000	18	2026-03-17 05:32:15.594449
131	33	1	25000	25	2026-03-17 04:49:45.520455
132	10	1	20000	37	2026-03-17 04:48:15.180236
133	58	1	30000	21	2026-03-17 04:38:36.807099
134	3	1	20000	9	2026-03-17 02:15:17.378475
135	189	1	25000	43	2026-03-17 01:42:47.937705
136	72	1	25000	30	2026-03-17 01:33:46.610402
137	132	1	20000	7	2026-03-16 22:50:17.380212
138	43	1	28000	13	2026-03-16 22:37:48.951222
139	56	1	30000	13	2026-03-16 20:07:14.256349
140	200	1	10000	40	2026-03-16 16:05:43.119799
141	57	1	30000	17	2026-03-16 15:31:15.756739
142	32	1	25000	21	2026-03-16 14:57:49.78638
143	229	1	12000	12	2026-03-16 14:31:32.359621
144	196	1	10000	24	2026-03-16 14:20:29.41362
145	47	1	28000	29	2026-03-16 09:22:13.390295
146	250	1	12000	48	2026-03-16 07:59:38.992392
147	241	1	12000	12	2026-03-16 04:39:24.943065
148	18	1	22000	17	2026-03-15 23:59:33.537476
149	194	1	10000	16	2026-03-15 22:46:45.319687
150	121	1	28000	18	2026-03-15 22:42:44.24509
151	231	1	12000	20	2026-03-15 22:33:16.366251
152	119	1	28000	10	2026-03-15 21:54:04.343184
153	184	1	25000	23	2026-03-15 19:45:24.087282
154	105	1	27000	2	2026-03-15 18:52:49.116052
155	8	1	20000	29	2026-03-15 17:21:26.070271
156	114	2	54000	42	2026-03-15 10:14:57.929771
157	101	2	54000	42	2026-03-15 09:45:01.14974
158	238	2	24000	48	2026-03-15 09:07:45.171787
159	56	2	60000	13	2026-03-15 04:45:46.002938
160	47	2	56000	29	2026-03-15 03:52:26.851121
161	190	2	50000	47	2026-03-15 03:29:28.261009
162	29	2	50000	9	2026-03-14 23:47:45.319937
163	250	2	24000	48	2026-03-14 23:40:14.299028
164	81	2	50000	14	2026-03-14 23:12:02.407948
165	58	2	60000	21	2026-03-14 21:16:17.317939
166	145	2	44000	11	2026-03-14 19:34:15.310696
167	168	2	44000	7	2026-03-14 19:10:08.077116
168	225	2	20000	44	2026-03-14 15:23:38.998225
169	77	2	50000	50	2026-03-14 14:30:12.214607
170	174	2	44000	31	2026-03-14 12:45:25.458315
171	210	2	20000	32	2026-03-14 10:01:53.083803
172	67	2	50000	10	2026-03-14 07:34:26.15648
173	235	2	24000	36	2026-03-14 04:08:43.821452
174	10	2	40000	37	2026-03-14 02:26:16.229458
175	105	2	54000	2	2026-03-14 01:18:05.196139
176	65	2	60000	49	2026-03-14 00:45:16.984191
177	135	2	40000	19	2026-03-13 20:32:07.703111
178	107	2	54000	14	2026-03-13 18:07:11.007486
179	206	2	20000	16	2026-03-13 12:06:45.061449
180	88	2	50000	42	2026-03-13 12:06:40.028616
181	58	2	60000	21	2026-03-13 11:09:46.727089
182	199	2	20000	36	2026-03-13 10:57:05.466621
183	246	2	24000	32	2026-03-13 10:34:07.209851
184	109	2	54000	22	2026-03-13 09:54:23.964009
185	214	2	20000	48	2026-03-13 09:18:39.350232
186	196	2	20000	24	2026-03-13 09:16:02.867212
187	62	2	60000	37	2026-03-13 08:03:02.815467
188	54	2	60000	5	2026-03-13 07:51:20.549857
189	230	2	24000	16	2026-03-13 07:09:50.282226
190	139	2	40000	35	2026-03-13 06:37:51.89829
191	81	2	50000	14	2026-03-13 03:27:32.027022
192	163	2	44000	35	2026-03-13 02:16:31.414373
193	29	2	50000	9	2026-03-13 01:58:58.453152
194	1	2	40000	1	2026-03-13 00:54:52.094511
195	192	2	20000	8	2026-03-13 00:20:24.870509
196	192	2	20000	8	2026-03-12 21:21:02.764796
197	3	2	40000	9	2026-03-12 19:55:08.581097
198	53	2	60000	1	2026-03-12 17:13:52.586839
199	200	2	20000	40	2026-03-12 17:09:08.779423
200	44	2	56000	17	2026-03-12 14:05:45.345409
201	16	2	44000	9	2026-03-12 13:47:06.551085
202	222	2	20000	32	2026-03-12 12:26:44.579314
203	236	2	24000	40	2026-03-12 12:26:21.811564
204	156	2	44000	7	2026-03-12 04:16:07.757212
205	73	2	50000	34	2026-03-12 01:14:39.244995
206	71	2	50000	26	2026-03-12 00:49:52.932491
207	195	2	20000	20	2026-03-11 23:46:39.964257
208	224	2	20000	40	2026-03-11 23:21:35.907755
209	6	2	40000	21	2026-03-11 22:13:09.486518
210	89	2	50000	46	2026-03-11 18:51:50.269672
211	235	2	24000	36	2026-03-11 18:16:05.29737
212	153	2	44000	43	2026-03-11 16:33:38.789149
213	206	2	20000	16	2026-03-11 16:32:35.342741
214	115	2	54000	46	2026-03-11 10:55:43.580235
215	131	2	40000	3	2026-03-11 10:23:41.37061
216	142	2	40000	47	2026-03-11 10:10:31.971992
217	228	2	24000	8	2026-03-11 09:24:16.141922
218	108	2	54000	18	2026-03-11 06:49:20.87374
219	143	2	44000	3	2026-03-11 04:07:50.851535
220	25	2	44000	45	2026-03-11 01:11:30.198005
221	74	2	50000	38	2026-03-10 17:16:53.587711
222	50	2	56000	41	2026-03-10 13:11:16.454198
223	112	2	54000	34	2026-03-10 11:09:27.61421
224	198	2	20000	32	2026-03-10 10:18:23.083579
225	44	2	56000	17	2026-03-10 01:48:07.809709
226	203	2	20000	4	2026-03-10 01:12:05.762798
227	111	2	54000	30	2026-03-09 21:40:10.390708
228	2	2	40000	5	2026-03-09 21:26:43.91785
229	12	2	40000	45	2026-03-09 21:07:46.429469
230	18	2	44000	17	2026-03-09 18:56:30.002545
231	72	2	50000	30	2026-03-09 18:14:05.073718
232	9	2	40000	33	2026-03-09 16:40:42.854383
233	182	2	50000	15	2026-03-09 14:05:09.028239
234	164	2	44000	39	2026-03-09 13:40:47.302424
235	188	2	50000	39	2026-03-09 11:50:43.626702
236	249	2	24000	44	2026-03-09 08:08:18.437835
237	105	2	54000	2	2026-03-09 06:47:11.299405
238	4	2	40000	13	2026-03-09 04:57:29.20923
239	13	2	40000	49	2026-03-09 04:17:04.364366
240	239	2	24000	4	2026-03-09 02:37:11.769092
241	5	2	40000	17	2026-03-09 02:28:29.537727
242	20	2	44000	25	2026-03-09 00:04:12.715796
243	94	2	54000	14	2026-03-08 22:28:55.444622
244	246	2	24000	32	2026-03-08 21:07:09.546726
245	75	2	50000	42	2026-03-08 20:40:37.546714
246	26	2	44000	49	2026-03-08 19:33:57.94111
247	133	2	40000	11	2026-03-08 15:00:37.22641
248	114	2	54000	42	2026-03-08 14:35:37.618641
249	31	2	50000	17	2026-03-08 13:02:54.602345
250	12	2	40000	45	2026-03-08 11:51:42.067466
251	50	2	56000	41	2026-03-08 11:44:02.992442
252	125	2	56000	34	2026-03-08 11:03:41.508491
253	191	2	20000	4	2026-03-08 10:56:21.253553
254	102	2	54000	46	2026-03-08 07:41:50.282999
255	216	2	20000	8	2026-03-08 05:31:54.850878
256	227	2	24000	4	2026-03-08 03:48:21.436975
257	227	2	24000	4	2026-03-08 03:43:52.889603
258	184	2	50000	23	2026-03-08 03:16:40.966793
259	215	2	20000	4	2026-03-08 02:31:56.771431
260	50	2	56000	41	2026-03-08 01:39:08.069658
261	119	2	56000	10	2026-03-08 00:19:27.452328
262	69	2	50000	18	2026-03-08 00:17:39.989471
263	205	2	20000	12	2026-03-07 20:51:20.352975
264	120	2	56000	14	2026-03-07 20:11:34.426725
265	46	2	56000	25	2026-03-07 18:59:20.746815
266	1	2	40000	1	2026-03-07 18:44:24.346982
267	87	2	50000	38	2026-03-07 14:33:44.248767
268	116	2	54000	50	2026-03-07 13:55:45.908282
269	92	2	54000	2	2026-03-07 10:02:18.401642
270	159	2	44000	19	2026-03-07 08:51:40.77707
271	64	2	60000	45	2026-03-07 03:30:32.800076
272	154	2	44000	47	2026-03-07 03:25:53.788231
273	249	2	24000	44	2026-03-07 02:17:13.429019
274	166	2	44000	47	2026-03-06 23:07:52.098869
275	180	2	50000	7	2026-03-06 14:48:38.982358
276	87	2	50000	38	2026-03-06 13:59:18.74661
277	68	2	50000	14	2026-03-06 13:58:08.772753
278	171	2	44000	19	2026-03-06 02:45:37.811447
279	122	2	56000	22	2026-03-06 01:17:27.261813
280	152	2	44000	39	2026-03-05 19:29:37.373066
281	52	2	56000	49	2026-03-05 18:06:41.256854
282	103	2	54000	50	2026-03-05 12:01:41.056876
283	211	2	20000	36	2026-03-05 11:42:38.439605
284	169	2	44000	11	2026-03-05 10:48:11.194945
285	234	2	24000	32	2026-03-05 10:27:27.494507
286	233	2	24000	28	2026-03-05 09:39:57.321971
287	172	2	44000	23	2026-03-05 08:47:31.270777
288	51	2	56000	45	2026-03-05 07:55:33.934442
289	17	2	44000	13	2026-03-05 07:02:33.026357
290	110	2	54000	26	2026-03-05 06:55:06.21413
291	147	2	44000	19	2026-03-05 04:54:50.852389
292	139	2	40000	35	2026-03-05 03:19:11.842643
293	82	2	50000	18	2026-03-05 03:09:03.60401
294	31	2	50000	17	2026-03-05 02:50:01.703486
295	179	2	50000	3	2026-03-04 23:47:50.701037
296	122	2	56000	22	2026-03-04 22:03:51.177187
297	150	2	44000	31	2026-03-04 18:02:19.568036
298	78	2	50000	6	2026-03-04 16:25:52.425163
299	168	2	44000	7	2026-03-04 15:11:41.004586
300	104	2	54000	6	2026-03-04 15:02:38.432141
301	94	2	54000	14	2026-03-04 13:21:28.849159
302	11	2	40000	41	2026-03-04 11:15:41.942689
303	96	2	54000	22	2026-03-04 04:55:32.432319
304	217	2	20000	12	2026-03-04 02:03:42.801586
305	79	2	50000	2	2026-03-04 01:05:43.789214
306	98	2	54000	30	2026-03-04 00:58:44.666052
307	109	2	54000	22	2026-03-04 00:53:00.457811
308	119	2	56000	10	2026-03-03 20:23:53.217257
309	19	2	44000	21	2026-03-03 12:24:30.921305
310	53	2	60000	1	2026-03-03 12:01:18.881762
311	195	2	20000	20	2026-03-03 11:18:49.122819
312	125	2	56000	34	2026-03-03 10:06:05.322868
313	152	2	44000	39	2026-03-03 06:31:28.800388
314	219	2	20000	20	2026-03-03 05:17:29.563131
315	135	2	40000	19	2026-03-03 04:02:36.492443
316	182	2	50000	15	2026-03-03 03:42:54.183573
317	103	2	54000	50	2026-03-03 03:11:55.475874
318	153	2	44000	43	2026-03-02 23:25:32.62176
319	206	2	20000	16	2026-03-02 22:32:01.378588
320	78	2	50000	6	2026-03-02 21:44:19.161799
321	34	2	50000	29	2026-03-02 17:53:25.16582
322	102	2	54000	46	2026-03-02 17:10:50.090358
323	82	2	50000	18	2026-03-02 08:55:03.552305
324	136	2	40000	23	2026-03-02 08:07:11.524517
325	231	2	24000	20	2026-03-02 07:30:59.912547
326	172	2	44000	23	2026-03-02 06:34:19.653766
327	183	2	50000	19	2026-03-02 05:28:29.736998
328	49	2	56000	37	2026-03-02 05:10:48.627719
329	130	2	56000	6	2026-03-02 04:59:17.165047
330	23	2	44000	37	2026-03-02 04:43:29.201555
331	210	2	20000	32	2026-03-02 03:09:26.694505
332	250	2	24000	48	2026-03-02 00:53:24.869515
333	175	2	44000	35	2026-03-01 21:47:08.170608
334	238	2	24000	48	2026-03-01 21:10:07.096893
335	179	2	50000	3	2026-03-01 20:09:43.318375
336	149	2	44000	27	2026-03-01 13:29:31.033569
337	153	2	44000	43	2026-03-01 13:27:10.778704
338	244	2	24000	24	2026-03-01 12:19:17.974162
339	99	2	54000	34	2026-03-01 11:55:37.086458
340	208	2	20000	24	2026-03-01 11:14:34.265753
341	174	2	44000	31	2026-03-01 11:02:04.796002
342	237	2	24000	44	2026-03-01 07:18:45.359339
343	180	2	50000	7	2026-03-01 06:28:38.38703
344	88	2	50000	42	2026-03-01 06:13:20.315355
345	176	2	44000	39	2026-03-01 05:02:03.778029
346	93	2	54000	10	2026-03-01 03:21:07.027646
347	229	2	24000	12	2026-03-01 00:33:33.398213
348	191	2	20000	4	2026-03-01 00:07:02.818319
349	84	2	50000	26	2026-02-28 22:44:47.428863
350	84	2	50000	26	2026-02-28 13:39:11.819628
351	37	2	50000	41	2026-02-28 11:11:25.352729
352	219	2	20000	20	2026-02-28 07:14:15.940833
353	146	2	44000	15	2026-02-28 07:12:29.240819
354	243	2	24000	20	2026-02-28 06:17:38.806306
355	115	2	54000	46	2026-02-28 03:27:21.087655
356	8	2	40000	29	2026-02-28 01:58:56.83871
357	225	2	20000	44	2026-02-27 23:20:11.044637
358	121	2	56000	18	2026-02-27 22:38:31.015524
359	136	2	40000	23	2026-02-27 20:22:52.032685
360	143	2	44000	3	2026-02-27 17:33:45.606419
361	38	2	50000	45	2026-02-27 17:31:30.921097
362	57	2	60000	17	2026-02-27 17:28:00.319742
363	85	2	50000	30	2026-02-27 11:45:22.079171
364	6	2	40000	21	2026-02-27 07:05:13.782392
365	24	2	44000	41	2026-02-27 06:57:00.925954
366	97	2	54000	26	2026-02-27 03:17:36.177094
367	29	2	50000	9	2026-02-27 01:31:15.355203
368	23	2	44000	37	2026-02-27 01:19:08.065826
369	42	2	56000	9	2026-02-27 00:35:52.991779
370	180	2	50000	7	2026-02-26 20:16:11.99587
371	55	2	60000	9	2026-02-26 18:46:28.257183
372	234	2	24000	32	2026-02-26 18:00:14.741837
373	124	2	56000	30	2026-02-26 17:58:13.423103
374	229	2	24000	12	2026-02-26 14:54:05.868672
375	112	2	54000	34	2026-02-26 14:41:05.727376
376	246	2	24000	32	2026-02-26 14:24:15.424764
377	230	2	24000	16	2026-02-26 12:06:30.382476
378	59	2	60000	25	2026-02-26 10:43:20.417341
379	4	2	40000	13	2026-02-26 02:12:42.838427
380	213	2	20000	44	2026-02-26 01:11:38.16402
381	205	2	20000	12	2026-02-26 01:02:10.643513
382	138	2	40000	31	2026-02-26 00:32:04.429606
383	148	2	44000	23	2026-02-25 23:46:08.987477
384	158	2	44000	15	2026-02-25 21:13:48.631468
385	123	2	56000	26	2026-02-25 20:49:40.17411
386	141	2	40000	43	2026-02-25 19:23:42.057199
387	63	2	60000	41	2026-02-25 18:30:26.417911
388	131	2	40000	3	2026-02-25 18:14:57.675882
389	105	2	54000	2	2026-02-25 17:57:40.516722
390	16	2	44000	9	2026-02-25 16:53:09.227638
391	55	2	60000	9	2026-02-25 16:50:04.352634
392	199	2	20000	36	2026-02-25 16:08:31.953237
393	144	2	44000	7	2026-02-25 15:28:59.133373
394	91	2	50000	6	2026-02-25 13:15:50.024353
395	90	2	50000	50	2026-02-25 12:55:37.909924
396	200	2	20000	40	2026-02-25 12:06:16.961426
397	76	2	50000	46	2026-02-25 10:00:34.845279
398	41	2	56000	5	2026-02-25 07:28:35.147929
399	192	2	20000	8	2026-02-25 04:54:19.219925
400	3	2	40000	9	2026-02-25 04:21:59.501781
401	38	2	50000	45	2026-02-25 02:49:56.060913
402	99	2	54000	34	2026-02-25 00:34:01.942429
403	89	2	50000	46	2026-02-25 00:30:30.370797
404	24	2	44000	41	2026-02-24 19:33:24.604645
405	43	2	56000	13	2026-02-24 17:56:38.692056
406	208	2	20000	24	2026-02-24 16:04:27.884885
407	241	2	24000	12	2026-02-24 15:46:17.377874
408	27	2	50000	1	2026-02-24 13:51:00.261603
409	63	2	60000	41	2026-02-24 05:58:04.507979
410	152	2	44000	39	2026-02-24 05:25:27.394504
411	127	2	56000	42	2026-02-23 21:28:24.504519
412	124	2	56000	30	2026-02-23 18:49:17.451513
413	64	2	60000	45	2026-02-23 17:17:46.201472
414	58	2	60000	21	2026-02-23 17:03:16.896879
415	224	2	20000	40	2026-02-23 15:46:55.742292
416	201	2	20000	44	2026-02-23 13:11:35.918361
417	131	2	40000	3	2026-02-23 11:35:33.491207
418	78	2	50000	6	2026-02-23 10:12:14.757481
419	61	2	60000	33	2026-02-23 09:23:04.83193
420	250	2	24000	48	2026-02-23 08:34:36.881033
421	62	2	60000	37	2026-02-23 07:45:24.049
422	142	2	40000	47	2026-02-23 07:20:58.909998
423	176	2	44000	39	2026-02-23 05:44:59.276827
424	243	2	24000	20	2026-02-22 22:04:14.240464
425	41	2	56000	5	2026-02-22 21:44:04.604771
426	37	2	50000	41	2026-02-22 20:26:35.816062
427	147	2	44000	19	2026-02-22 20:07:34.442378
428	44	2	56000	17	2026-02-22 15:03:04.452072
429	45	2	56000	21	2026-02-22 14:22:09.945389
430	32	2	50000	21	2026-02-22 11:13:18.121289
431	226	2	20000	48	2026-02-22 09:20:44.815587
432	206	2	20000	16	2026-02-22 04:39:48.432135
433	162	2	44000	31	2026-02-22 01:04:51.948505
434	222	2	20000	32	2026-02-21 23:46:01.537167
435	231	2	24000	20	2026-02-21 21:42:08.633804
436	60	2	60000	29	2026-02-21 21:22:02.661135
437	103	2	54000	50	2026-02-21 20:25:22.728705
438	189	2	50000	43	2026-02-21 19:30:56.564301
439	77	2	50000	50	2026-02-21 14:39:33.574004
440	66	2	50000	2	2026-02-21 14:07:28.860743
441	132	2	40000	7	2026-02-21 14:03:20.708512
442	233	2	24000	28	2026-02-21 10:47:04.956627
443	61	2	60000	33	2026-02-21 06:59:09.549934
444	49	2	56000	37	2026-02-21 04:59:07.763611
445	227	2	24000	4	2026-02-21 02:31:25.124002
446	214	2	20000	48	2026-02-21 00:57:10.64181
447	235	2	24000	36	2026-02-21 00:21:05.364033
448	30	3	75000	13	2026-02-20 18:34:06.195659
449	97	3	81000	26	2026-02-20 18:08:13.170035
450	59	3	90000	25	2026-02-20 14:45:07.48268
451	221	3	30000	28	2026-02-20 14:36:06.135089
452	140	3	60000	39	2026-02-20 13:04:50.839653
453	137	3	60000	27	2026-02-20 11:37:20.727123
454	197	3	30000	28	2026-02-20 10:36:41.011943
455	64	3	90000	45	2026-02-20 08:59:17.953646
456	143	3	66000	3	2026-02-20 08:16:00.559919
457	138	3	60000	31	2026-02-20 06:18:27.146804
458	80	3	75000	10	2026-02-20 03:11:50.62078
459	58	3	90000	21	2026-02-20 01:26:36.224614
460	25	3	66000	45	2026-02-20 00:38:30.477384
461	72	3	75000	30	2026-02-19 23:44:21.872291
462	11	3	60000	41	2026-02-19 21:57:15.199095
463	188	3	75000	39	2026-02-19 16:49:27.875284
464	169	3	66000	11	2026-02-19 14:29:41.705847
465	67	3	75000	10	2026-02-19 14:16:59.47735
466	232	3	36000	24	2026-02-19 12:11:01.62299
467	188	3	75000	39	2026-02-19 11:49:47.437414
468	196	3	30000	24	2026-02-19 11:11:32.803683
469	89	3	75000	46	2026-02-19 11:00:18.883652
470	12	3	60000	45	2026-02-19 09:35:59.908809
471	95	3	81000	18	2026-02-19 07:06:00.372692
472	232	3	36000	24	2026-02-19 06:54:32.555524
473	149	3	66000	27	2026-02-19 04:43:39.401104
474	158	3	66000	15	2026-02-19 03:05:54.182274
475	28	3	75000	5	2026-02-19 02:33:23.30458
476	129	3	84000	50	2026-02-18 18:39:55.95534
477	208	3	30000	24	2026-02-18 16:38:42.311859
478	242	3	36000	16	2026-02-18 14:35:33.12467
479	46	3	84000	25	2026-02-18 13:59:05.724308
480	135	3	60000	19	2026-02-18 10:24:24.56923
481	217	3	30000	12	2026-02-18 08:07:58.645992
482	14	3	66000	1	2026-02-18 08:05:11.819311
483	162	3	66000	31	2026-02-17 22:00:04.606283
484	207	3	30000	20	2026-02-17 16:17:04.823331
485	204	3	30000	8	2026-02-17 12:48:06.735482
486	237	3	36000	44	2026-02-17 12:20:01.518924
487	174	3	66000	31	2026-02-17 08:46:32.199742
488	249	3	36000	44	2026-02-17 08:06:29.061252
489	51	3	84000	45	2026-02-17 07:25:01.055107
490	101	3	81000	42	2026-02-17 06:20:07.004036
491	153	3	66000	43	2026-02-17 02:02:25.253113
492	231	3	36000	20	2026-02-16 23:39:18.659909
493	221	3	30000	28	2026-02-16 22:19:20.656734
494	183	3	75000	19	2026-02-16 21:10:40.869598
495	120	3	84000	14	2026-02-16 11:30:29.556045
496	106	3	81000	10	2026-02-16 10:45:52.619101
497	11	3	60000	41	2026-02-16 10:09:33.120091
498	165	3	66000	43	2026-02-16 08:21:39.092327
499	99	3	81000	34	2026-02-16 07:11:13.974277
500	210	3	30000	32	2026-02-16 05:01:04.309786
501	10	3	60000	37	2026-02-16 01:48:02.999248
502	14	3	66000	1	2026-02-15 21:28:03.223372
503	184	3	75000	23	2026-02-15 18:45:33.763353
504	114	3	81000	42	2026-02-15 18:11:24.894143
505	88	3	75000	42	2026-02-15 15:08:51.652248
506	127	3	84000	42	2026-02-15 14:49:27.985523
507	117	3	81000	6	2026-02-15 13:33:51.735669
508	230	3	36000	16	2026-02-15 12:06:24.997431
509	130	3	84000	6	2026-02-15 10:37:33.716085
510	161	3	66000	27	2026-02-15 09:52:59.966128
511	134	3	60000	15	2026-02-15 08:18:21.910555
512	128	3	84000	46	2026-02-15 05:16:47.185265
513	41	3	84000	5	2026-02-15 03:36:08.02762
514	60	3	90000	29	2026-02-15 01:28:04.536989
515	108	3	81000	18	2026-02-15 01:26:33.138749
516	180	3	75000	7	2026-02-15 00:04:35.518232
517	215	3	30000	4	2026-02-14 22:04:54.710331
518	213	3	30000	44	2026-02-14 20:01:49.653537
519	29	3	75000	9	2026-02-14 17:43:01.436218
520	10	3	60000	37	2026-02-14 16:12:24.434102
521	190	3	75000	47	2026-02-14 16:09:48.907768
522	162	3	66000	31	2026-02-14 14:42:09.740771
523	220	3	30000	24	2026-02-14 12:56:02.578549
524	78	3	75000	6	2026-02-14 08:39:06.469923
525	182	3	75000	15	2026-02-14 03:52:50.746935
526	144	3	66000	7	2026-02-14 03:13:20.859162
527	56	3	90000	13	2026-02-14 00:35:27.748015
528	51	3	84000	45	2026-02-14 00:04:01.644628
529	166	3	66000	47	2026-02-13 22:32:44.688259
530	113	3	81000	38	2026-02-13 17:45:42.479158
531	232	3	36000	24	2026-02-13 13:02:08.226721
532	45	3	84000	21	2026-02-13 12:49:57.728405
533	38	3	75000	45	2026-02-13 10:05:58.258286
534	83	3	75000	22	2026-02-13 09:42:34.998565
535	178	3	66000	47	2026-02-13 08:22:09.801429
536	26	3	66000	49	2026-02-13 06:42:15.145106
537	144	3	66000	7	2026-02-13 02:15:34.508315
538	102	3	81000	46	2026-02-13 00:51:55.624977
539	178	3	66000	47	2026-02-13 00:35:08.977225
540	129	3	84000	50	2026-02-12 23:58:29.156424
541	106	3	81000	10	2026-02-12 21:44:57.180475
542	54	3	90000	5	2026-02-12 19:39:51.232493
543	124	3	84000	30	2026-02-12 17:09:53.779211
544	107	3	81000	14	2026-02-12 16:58:10.736293
545	233	3	36000	28	2026-02-12 12:32:12.612392
546	61	3	90000	33	2026-02-12 12:24:56.656977
547	183	3	75000	19	2026-02-12 07:15:06.898083
548	106	3	81000	10	2026-02-12 03:37:18.037445
549	2	3	60000	5	2026-02-12 02:21:56.895629
550	80	3	75000	10	2026-02-12 02:19:23.520272
551	175	3	66000	35	2026-02-12 00:35:56.896554
552	240	3	36000	8	2026-02-12 00:33:20.438982
553	212	3	30000	40	2026-02-11 23:30:19.561285
554	177	3	66000	43	2026-02-11 23:14:38.598285
555	185	3	75000	27	2026-02-11 20:57:27.604104
556	169	3	66000	11	2026-02-11 16:45:29.129419
557	137	3	60000	27	2026-02-11 14:19:39.072805
558	212	3	30000	40	2026-02-11 09:44:48.478918
559	167	3	66000	3	2026-02-11 08:59:57.442027
560	91	3	75000	6	2026-02-11 07:36:07.312675
561	41	3	84000	5	2026-02-11 01:42:16.023235
562	168	3	66000	7	2026-02-10 23:01:02.908387
563	28	3	75000	5	2026-02-10 20:51:31.635959
564	156	3	66000	7	2026-02-10 20:33:03.951003
565	43	3	84000	13	2026-02-10 19:01:22.866985
566	51	3	84000	45	2026-02-10 17:02:24.590685
567	177	3	66000	43	2026-02-10 15:09:25.052715
568	163	3	66000	35	2026-02-10 13:23:59.5315
569	173	3	66000	27	2026-02-10 12:31:31.536506
570	22	3	66000	33	2026-02-10 03:13:49.229568
571	177	3	66000	43	2026-02-10 02:22:19.141314
572	86	3	75000	34	2026-02-10 01:22:33.465644
573	6	3	60000	21	2026-02-09 18:12:01.599379
574	201	3	30000	44	2026-02-09 13:11:33.267445
575	124	3	84000	30	2026-02-09 12:26:31.708291
576	62	3	90000	37	2026-02-09 10:35:48.44825
577	46	3	84000	25	2026-02-09 07:52:41.288452
578	241	3	36000	12	2026-02-09 07:48:32.97116
579	156	3	66000	7	2026-02-09 04:37:20.339646
580	71	3	75000	26	2026-02-09 02:46:40.586763
581	25	3	66000	45	2026-02-09 01:29:30.01496
582	100	3	81000	38	2026-02-09 00:28:43.0548
583	200	3	30000	40	2026-02-08 22:34:13.228283
584	160	3	66000	23	2026-02-08 21:26:09.780899
585	16	3	66000	9	2026-02-08 20:44:47.018404
586	165	3	66000	43	2026-02-08 17:50:17.355595
587	133	3	60000	11	2026-02-08 16:50:46.95357
588	39	3	75000	49	2026-02-08 16:46:10.62907
589	22	3	66000	33	2026-02-08 16:43:57.044599
590	226	3	30000	48	2026-02-08 15:24:36.649684
591	42	3	84000	9	2026-02-08 15:14:15.137855
592	66	3	75000	2	2026-02-08 14:40:32.533615
593	194	3	30000	16	2026-02-08 14:36:03.608618
594	9	3	60000	33	2026-02-08 14:19:32.863935
595	2	3	60000	5	2026-02-08 12:29:17.090069
596	244	3	36000	24	2026-02-08 11:50:19.555637
597	239	3	36000	4	2026-02-08 11:24:24.045561
598	66	3	75000	2	2026-02-08 06:27:29.150287
599	24	3	66000	41	2026-02-08 04:48:07.584917
600	142	3	60000	47	2026-02-08 03:16:58.496473
601	30	3	75000	13	2026-02-08 02:00:41.663393
602	93	3	81000	10	2026-02-08 01:49:25.098757
603	213	3	30000	44	2026-02-07 23:28:33.56104
604	125	3	84000	34	2026-02-07 21:50:21.663969
605	243	3	36000	20	2026-02-07 20:11:06.59152
606	67	3	75000	10	2026-02-07 15:47:54.429713
607	129	3	84000	50	2026-02-07 10:18:18.457944
608	19	3	66000	21	2026-02-07 07:58:40.61279
609	5	3	60000	17	2026-02-07 06:00:07.38701
610	137	3	60000	27	2026-02-07 04:40:02.286353
611	245	3	36000	28	2026-02-07 04:07:44.294577
612	223	3	30000	36	2026-02-07 03:54:24.770835
613	195	3	30000	20	2026-02-07 03:50:11.976001
614	90	3	75000	50	2026-02-07 03:22:25.345653
615	228	3	36000	8	2026-02-07 02:32:01.080163
616	212	3	30000	40	2026-02-07 02:03:12.340355
617	21	3	66000	29	2026-02-07 00:21:38.924907
618	76	3	75000	46	2026-02-06 23:49:11.477473
619	233	3	36000	28	2026-02-06 20:12:24.243824
620	43	3	84000	13	2026-02-06 17:53:16.443447
621	157	3	66000	11	2026-02-06 16:30:52.091595
622	149	3	66000	27	2026-02-06 14:18:41.481634
623	75	3	75000	42	2026-02-06 10:47:11.19214
624	177	3	66000	43	2026-02-06 03:08:21.333516
625	141	3	60000	43	2026-02-06 02:43:05.151007
626	27	3	75000	1	2026-02-06 02:24:51.604506
627	137	3	60000	27	2026-02-05 23:43:43.82146
628	19	3	66000	21	2026-02-05 22:27:52.381927
629	179	3	75000	3	2026-02-05 21:18:51.664256
630	208	3	30000	24	2026-02-05 20:27:53.785763
631	132	3	60000	7	2026-02-05 18:43:11.444511
632	26	3	66000	49	2026-02-05 17:23:37.316058
633	143	3	66000	3	2026-02-05 11:37:20.535254
634	211	3	30000	36	2026-02-05 09:39:28.933844
635	83	3	75000	22	2026-02-05 09:36:58.160777
636	47	3	84000	29	2026-02-05 08:04:41.471161
637	203	3	30000	4	2026-02-05 06:24:06.72519
638	173	3	66000	27	2026-02-05 06:19:51.232375
639	187	3	75000	35	2026-02-05 03:30:41.235009
640	104	3	81000	6	2026-02-05 02:33:48.743717
641	130	3	84000	6	2026-02-05 00:23:36.850276
642	30	3	75000	13	2026-02-04 16:31:06.215577
643	57	3	90000	17	2026-02-04 15:15:54.428578
644	31	3	75000	17	2026-02-04 11:00:25.591234
645	108	3	81000	18	2026-02-04 05:50:00.469994
646	39	3	75000	49	2026-02-04 04:50:00.787351
647	148	3	66000	23	2026-02-04 04:40:17.753222
648	121	3	84000	18	2026-02-04 04:15:24.72041
649	247	3	36000	36	2026-02-04 04:07:19.786081
650	238	3	36000	48	2026-02-04 02:14:31.477545
651	105	3	81000	2	2026-02-03 23:58:22.398234
652	162	3	66000	31	2026-02-03 22:43:06.094395
653	61	3	90000	33	2026-02-03 22:31:16.844319
654	92	3	81000	2	2026-02-03 20:37:03.138687
655	84	3	75000	26	2026-02-03 20:05:51.745631
656	198	3	30000	32	2026-02-03 16:40:20.468916
657	164	3	66000	39	2026-02-03 15:58:03.528115
658	232	3	36000	24	2026-02-03 15:26:43.986799
659	14	3	66000	1	2026-02-03 13:28:50.122041
660	112	3	81000	34	2026-02-03 08:39:04.045778
661	112	3	81000	34	2026-02-03 08:33:43.62813
662	125	3	84000	34	2026-02-03 08:10:50.804224
663	171	3	66000	19	2026-02-03 07:06:51.148846
664	226	3	30000	48	2026-02-03 04:27:52.29184
665	230	3	36000	16	2026-02-03 04:24:40.701441
666	40	3	84000	1	2026-02-03 02:13:03.108011
667	246	3	36000	32	2026-02-03 00:21:20.625784
668	39	3	75000	49	2026-02-02 23:42:19.982595
669	163	3	66000	35	2026-02-02 16:21:39.490511
670	149	3	66000	27	2026-02-02 13:07:09.590924
671	86	3	75000	34	2026-02-02 12:03:00.76546
672	33	3	75000	25	2026-02-02 08:41:15.888945
673	224	3	30000	40	2026-02-02 01:37:26.554521
674	13	3	60000	49	2026-02-02 00:13:16.263953
675	123	3	84000	26	2026-02-01 23:31:25.069456
676	247	3	36000	36	2026-02-01 22:13:53.006244
677	109	3	81000	22	2026-02-01 20:52:18.508076
678	186	3	75000	31	2026-02-01 18:00:33.516365
679	82	3	75000	18	2026-02-01 17:54:37.904536
680	30	3	75000	13	2026-02-01 17:27:00.019605
681	87	3	75000	38	2026-02-01 15:36:45.807956
682	218	3	30000	16	2026-02-01 12:21:45.494888
683	247	3	36000	36	2026-02-01 05:32:13.883748
684	194	3	30000	16	2026-02-01 05:12:48.992647
685	134	3	60000	15	2026-02-01 04:46:08.467557
686	242	3	36000	16	2026-02-01 03:39:01.356222
687	104	3	81000	6	2026-02-01 03:28:04.248946
688	126	3	84000	38	2026-02-01 02:27:12.966808
689	203	3	30000	4	2026-02-01 01:58:27.122065
690	163	3	66000	35	2026-02-01 01:36:39.877956
691	12	3	60000	45	2026-02-01 01:27:22.801643
692	181	3	75000	11	2026-01-31 23:31:38.729234
693	145	3	66000	11	2026-01-31 23:10:37.778185
694	40	3	84000	1	2026-01-31 21:19:15.83116
695	44	3	84000	17	2026-01-31 21:16:57.74209
696	8	3	60000	29	2026-01-31 20:28:56.694895
697	179	3	75000	3	2026-01-31 20:22:52.54304
698	203	3	30000	4	2026-01-31 18:39:28.487851
699	210	3	30000	32	2026-01-31 15:41:27.923426
700	52	3	84000	49	2026-01-31 11:53:00.165335
701	124	3	84000	30	2026-01-31 10:38:55.638642
702	220	3	30000	24	2026-01-31 10:19:43.105686
703	62	3	90000	37	2026-01-31 09:54:51.463476
704	225	3	30000	44	2026-01-31 09:50:43.744542
705	45	3	84000	21	2026-01-31 05:00:15.193321
706	202	3	30000	48	2026-01-31 00:17:36.402119
707	95	3	81000	18	2026-01-30 22:30:05.837531
708	163	3	66000	35	2026-01-30 21:41:31.845229
709	72	3	75000	30	2026-01-30 19:45:12.770744
710	42	3	84000	9	2026-01-30 18:54:20.609112
711	202	3	30000	48	2026-01-30 17:11:39.980054
712	238	3	36000	48	2026-01-30 16:49:48.046704
713	185	3	75000	27	2026-01-30 14:25:13.763999
714	144	3	66000	7	2026-01-30 12:21:21.454911
715	128	3	84000	46	2026-01-30 12:10:57.079979
716	141	3	60000	43	2026-01-30 11:26:09.886939
717	83	3	75000	22	2026-01-30 10:36:42.308256
718	35	3	75000	33	2026-01-30 10:10:45.139744
719	4	3	60000	13	2026-01-30 09:39:30.671918
720	9	3	60000	33	2026-01-30 09:21:33.578775
721	95	3	81000	18	2026-01-30 02:32:58.433103
722	48	3	84000	33	2026-01-29 21:10:53.367127
723	224	3	30000	40	2026-01-29 19:39:55.618617
724	23	3	66000	37	2026-01-29 19:05:49.981275
725	211	3	30000	36	2026-01-29 18:49:25.8503
726	86	3	75000	34	2026-01-29 17:58:54.990612
727	229	3	36000	12	2026-01-29 17:43:14.069338
728	22	3	66000	33	2026-01-29 14:58:15.951856
729	192	3	30000	8	2026-01-29 14:52:22.651975
730	28	3	75000	5	2026-01-29 12:22:42.151487
731	21	4	88000	29	2026-01-29 08:24:03.992186
732	35	4	100000	33	2026-01-29 05:35:37.820612
733	128	4	112000	46	2026-01-29 02:44:42.191379
734	151	4	88000	35	2026-01-29 02:33:17.52875
735	235	4	48000	36	2026-01-29 00:24:45.187651
736	18	4	88000	17	2026-01-28 19:54:16.328282
737	191	4	40000	4	2026-01-28 19:11:20.061926
738	174	4	88000	31	2026-01-28 18:56:50.087237
739	212	4	40000	40	2026-01-28 17:08:59.43905
740	203	4	40000	4	2026-01-28 17:08:47.229599
741	77	4	100000	50	2026-01-28 16:14:21.32632
742	102	4	108000	46	2026-01-28 16:01:56.23608
743	193	4	40000	12	2026-01-28 13:30:00.341496
744	146	4	88000	15	2026-01-28 08:40:57.041066
745	116	4	108000	50	2026-01-28 07:33:51.153222
746	138	4	80000	31	2026-01-28 07:21:24.132229
747	148	4	88000	23	2026-01-28 07:19:29.021054
748	160	4	88000	23	2026-01-28 06:04:28.111054
749	81	4	100000	14	2026-01-28 05:56:39.548259
750	113	4	108000	38	2026-01-28 04:08:32.957226
751	57	4	120000	17	2026-01-28 02:25:02.94436
752	16	4	88000	9	2026-01-27 22:07:44.156083
753	7	4	80000	25	2026-01-27 20:48:51.420574
754	22	4	88000	33	2026-01-27 20:17:01.849108
755	21	4	88000	29	2026-01-27 19:56:57.105705
756	225	4	40000	44	2026-01-27 15:43:37.213694
757	99	4	108000	34	2026-01-27 14:45:44.227467
758	216	4	40000	8	2026-01-27 12:59:27.514472
759	2	4	80000	5	2026-01-27 12:36:56.344183
760	237	4	48000	44	2026-01-27 10:42:25.355289
761	20	4	88000	25	2026-01-27 10:24:24.500599
762	233	4	48000	28	2026-01-27 06:39:40.249579
763	42	4	112000	9	2026-01-27 02:32:50.437318
764	46	4	112000	25	2026-01-27 00:48:37.215585
765	146	4	88000	15	2026-01-26 23:38:42.844432
766	109	4	108000	22	2026-01-26 21:48:49.540383
767	205	4	40000	12	2026-01-26 21:31:56.284978
768	62	4	120000	37	2026-01-26 20:36:02.814575
769	104	4	108000	6	2026-01-26 18:30:32.332753
770	118	4	112000	2	2026-01-26 18:03:06.612428
771	114	4	108000	42	2026-01-26 17:51:36.950641
772	248	4	48000	40	2026-01-26 08:28:36.843482
773	114	4	108000	42	2026-01-26 07:29:03.842875
774	217	4	40000	12	2026-01-26 06:53:08.550586
775	236	4	48000	40	2026-01-26 04:36:51.670506
776	159	4	88000	19	2026-01-26 04:02:03.050681
777	55	4	120000	9	2026-01-26 03:55:45.108778
778	117	4	108000	6	2026-01-26 00:57:26.005946
779	137	4	80000	27	2026-01-25 21:50:21.829581
780	49	4	112000	37	2026-01-25 19:29:10.770409
781	186	4	100000	31	2026-01-25 19:24:09.0224
782	52	4	112000	49	2026-01-25 18:11:51.534212
783	157	4	88000	11	2026-01-25 16:00:53.849281
784	49	4	112000	37	2026-01-25 11:50:06.120427
785	38	4	100000	45	2026-01-25 10:49:26.346375
786	29	4	100000	9	2026-01-25 07:00:45.160239
787	194	4	40000	16	2026-01-25 04:42:09.23211
788	138	4	80000	31	2026-01-25 03:44:05.290302
789	214	4	40000	48	2026-01-25 01:44:35.133817
790	7	4	80000	25	2026-01-25 00:46:56.928726
791	172	4	88000	23	2026-01-25 00:25:40.339394
792	45	4	112000	21	2026-01-25 00:04:00.055212
793	153	4	88000	43	2026-01-24 16:32:56.789877
794	202	4	40000	48	2026-01-24 12:56:23.565185
795	100	4	108000	38	2026-01-24 12:26:17.5172
796	127	4	112000	42	2026-01-24 11:41:50.110652
797	116	4	108000	50	2026-01-24 11:25:06.502766
798	54	4	120000	5	2026-01-24 07:17:30.946574
799	48	4	112000	33	2026-01-24 06:42:42.743487
800	54	4	120000	5	2026-01-24 06:33:28.219864
801	74	4	100000	38	2026-01-24 01:28:38.659685
802	160	4	88000	23	2026-01-23 23:56:25.222768
803	119	4	112000	10	2026-01-23 23:27:44.947747
804	160	4	88000	23	2026-01-23 21:31:05.653143
805	34	4	100000	29	2026-01-23 21:30:54.936778
806	59	4	120000	25	2026-01-23 20:40:34.16227
807	187	4	100000	35	2026-01-23 20:01:56.350946
808	135	4	80000	19	2026-01-23 19:53:54.739452
809	136	4	80000	23	2026-01-23 18:26:05.995475
810	193	4	40000	12	2026-01-23 17:01:56.454511
811	20	4	88000	25	2026-01-23 15:44:05.455832
812	55	4	120000	9	2026-01-23 15:23:21.233896
813	139	4	80000	35	2026-01-23 15:08:16.748024
814	205	4	40000	12	2026-01-23 11:10:15.081985
815	165	4	88000	43	2026-01-23 02:59:24.894037
816	122	4	112000	22	2026-01-22 22:36:49.591293
817	73	4	100000	34	2026-01-22 22:14:14.934751
818	20	4	88000	25	2026-01-22 22:09:00.310455
819	60	4	120000	29	2026-01-22 21:27:33.553939
820	155	4	88000	3	2026-01-22 20:01:50.963216
821	63	4	120000	41	2026-01-22 19:26:41.540895
822	201	4	40000	44	2026-01-22 17:05:36.889235
823	236	4	48000	40	2026-01-22 14:23:44.78038
824	159	4	88000	19	2026-01-22 13:29:27.907018
825	181	4	100000	11	2026-01-22 10:43:17.439962
826	26	4	88000	49	2026-01-22 10:09:05.507991
827	111	4	108000	30	2026-01-22 09:55:30.117081
828	134	4	80000	15	2026-01-22 08:35:45.778291
829	108	4	108000	18	2026-01-22 07:58:13.109739
830	69	4	100000	18	2026-01-22 03:45:42.113317
831	173	4	88000	27	2026-01-22 00:46:12.420904
832	15	4	88000	5	2026-01-21 19:50:00.283058
833	127	4	112000	42	2026-01-21 19:25:05.424661
834	111	4	108000	30	2026-01-21 18:41:45.705738
835	97	4	108000	26	2026-01-21 12:58:23.483283
836	28	4	100000	5	2026-01-21 12:21:42.946386
837	184	4	100000	23	2026-01-21 09:41:00.907096
838	53	4	120000	1	2026-01-21 09:21:22.188959
839	215	4	40000	4	2026-01-21 03:27:28.4945
840	101	4	108000	42	2026-01-21 03:22:38.249402
841	11	4	80000	41	2026-01-21 00:10:19.211836
842	110	4	108000	26	2026-01-20 23:02:05.515146
843	42	4	112000	9	2026-01-20 22:17:33.473338
844	59	4	120000	25	2026-01-20 16:51:39.594683
845	48	4	112000	33	2026-01-20 16:11:20.888038
846	89	4	100000	46	2026-01-20 15:24:26.679368
847	123	4	112000	26	2026-01-20 14:31:13.401865
848	186	4	100000	31	2026-01-20 14:30:50.973706
849	118	4	112000	2	2026-01-20 14:03:36.712615
850	224	4	40000	40	2026-01-20 11:33:47.860282
851	123	4	112000	26	2026-01-20 10:25:21.505015
852	188	4	100000	39	2026-01-20 10:09:04.452519
853	38	4	100000	45	2026-01-20 08:02:15.844636
854	214	4	40000	48	2026-01-20 06:23:37.338215
855	53	4	120000	1	2026-01-20 06:09:24.560962
856	90	4	100000	50	2026-01-20 04:47:58.067558
857	128	4	112000	46	2026-01-20 01:58:18.066983
858	151	4	88000	35	2026-01-20 00:42:56.879491
859	159	4	88000	19	2026-01-19 22:21:32.450203
860	98	4	108000	30	2026-01-19 20:54:13.711213
861	74	4	100000	38	2026-01-19 16:51:10.669564
862	94	4	108000	14	2026-01-19 16:38:29.007627
863	57	4	120000	17	2026-01-19 16:28:37.963455
864	69	4	100000	18	2026-01-19 15:31:25.067797
865	170	4	88000	15	2026-01-19 15:10:27.956857
866	111	4	108000	30	2026-01-19 13:17:53.596916
867	207	4	40000	20	2026-01-19 12:02:08.379739
868	32	4	100000	21	2026-01-19 10:01:16.281499
869	18	4	88000	17	2026-01-19 05:49:56.686419
870	102	4	108000	46	2026-01-19 04:24:17.30398
871	96	4	108000	22	2026-01-19 02:02:51.843155
872	48	4	112000	33	2026-01-18 21:27:00.244423
873	118	4	112000	2	2026-01-18 17:13:57.65319
874	13	4	80000	49	2026-01-18 16:34:48.577573
875	48	4	112000	33	2026-01-18 14:42:37.885844
876	97	4	108000	26	2026-01-18 13:56:54.429937
877	226	4	40000	48	2026-01-18 13:12:17.686331
878	3	4	80000	9	2026-01-18 12:30:07.753961
879	150	4	88000	31	2026-01-18 08:52:50.346026
880	217	4	40000	12	2026-01-18 07:12:04.441094
881	56	4	120000	13	2026-01-18 06:33:00.715126
882	236	4	48000	40	2026-01-18 05:59:09.86232
883	162	4	88000	31	2026-01-18 04:53:08.9631
884	248	4	48000	40	2026-01-18 04:39:15.749146
885	128	4	112000	46	2026-01-18 04:00:31.312463
886	221	4	40000	28	2026-01-18 02:25:31.830813
887	219	4	40000	20	2026-01-18 02:13:27.956831
888	240	4	48000	8	2026-01-18 00:28:11.360004
889	201	4	40000	44	2026-01-17 21:47:43.672026
890	50	4	112000	41	2026-01-17 19:22:27.894567
891	249	4	48000	44	2026-01-17 17:34:28.674921
892	165	4	88000	43	2026-01-17 15:16:39.135564
893	210	4	40000	32	2026-01-17 15:10:06.619547
894	20	4	88000	25	2026-01-17 12:49:07.740558
895	118	4	112000	2	2026-01-17 08:46:26.153915
896	125	4	112000	34	2026-01-17 06:15:51.468171
897	76	4	100000	46	2026-01-17 04:17:19.637892
898	242	4	48000	16	2026-01-17 01:24:45.71488
899	4	4	80000	13	2026-01-17 01:02:55.085029
900	204	4	40000	8	2026-01-16 19:37:56.658703
901	65	4	120000	49	2026-01-16 18:43:18.155658
902	211	4	40000	36	2026-01-16 15:16:25.889516
903	113	4	108000	38	2026-01-16 15:07:17.804255
904	156	4	88000	7	2026-01-16 14:29:33.663679
905	36	4	100000	37	2026-01-16 14:11:42.966177
906	214	4	40000	48	2026-01-16 13:03:35.180776
907	106	4	108000	10	2026-01-16 07:35:45.780872
908	70	4	100000	22	2026-01-16 04:15:05.385038
909	154	4	88000	47	2026-01-16 02:03:39.976807
910	202	4	40000	48	2026-01-16 01:56:00.107258
911	218	4	40000	16	2026-01-15 23:40:34.398163
912	119	4	112000	10	2026-01-15 23:38:09.244246
913	195	4	40000	20	2026-01-15 22:36:57.625692
914	187	4	100000	35	2026-01-15 21:38:19.451344
915	132	4	80000	7	2026-01-15 21:34:42.421363
916	83	4	100000	22	2026-01-15 18:29:14.569048
917	52	4	112000	49	2026-01-15 17:44:55.587599
918	148	4	88000	23	2026-01-15 17:05:31.415279
919	113	4	108000	38	2026-01-15 16:39:55.040491
920	209	4	40000	28	2026-01-15 15:39:26.027416
921	209	4	40000	28	2026-01-15 13:01:26.30507
922	117	4	108000	6	2026-01-15 11:09:49.216024
923	73	4	100000	34	2026-01-15 10:38:00.565927
924	110	4	108000	26	2026-01-15 08:55:30.741943
925	117	4	108000	6	2026-01-15 06:49:15.532455
926	177	4	88000	43	2026-01-15 06:26:36.043389
927	115	4	108000	46	2026-01-15 05:14:14.752238
928	154	4	88000	47	2026-01-15 05:01:23.711152
929	189	4	100000	43	2026-01-15 04:53:17.238984
930	17	4	88000	13	2026-01-15 02:38:24.813086
931	70	4	100000	22	2026-01-15 02:23:16.691588
932	76	4	100000	46	2026-01-15 02:00:55.972611
933	32	4	100000	21	2026-01-14 23:25:23.310998
934	39	4	100000	49	2026-01-14 22:41:17.195094
935	145	4	88000	11	2026-01-14 22:12:02.113886
936	74	4	100000	38	2026-01-14 21:30:55.260791
937	166	4	88000	47	2026-01-14 20:09:20.301763
938	77	4	100000	50	2026-01-14 18:38:48.024417
939	151	4	88000	35	2026-01-14 18:20:36.469962
940	21	4	88000	29	2026-01-14 16:23:48.932141
941	185	4	100000	27	2026-01-14 14:38:50.869754
942	168	4	88000	7	2026-01-14 13:44:21.875262
943	216	4	40000	8	2026-01-14 13:38:28.005311
944	98	4	108000	30	2026-01-14 13:31:18.545562
945	47	4	112000	29	2026-01-14 12:26:06.266188
946	171	4	88000	19	2026-01-14 12:12:42.062344
947	171	4	88000	19	2026-01-14 10:15:46.724176
948	111	4	108000	30	2026-01-13 23:48:51.112646
949	16	4	88000	9	2026-01-13 22:07:42.714526
950	220	4	40000	24	2026-01-13 19:55:53.660459
951	245	4	48000	28	2026-01-13 17:20:43.363846
952	198	4	40000	32	2026-01-13 17:13:45.491052
953	179	4	100000	3	2026-01-13 14:17:28.99429
954	75	4	100000	42	2026-01-13 14:12:25.223059
955	103	4	108000	50	2026-01-13 11:20:04.021117
956	223	4	40000	36	2026-01-13 09:42:18.635971
957	69	4	100000	18	2026-01-13 07:13:37.220763
958	120	4	112000	14	2026-01-13 07:01:26.584359
959	100	4	108000	38	2026-01-13 06:25:43.042729
960	84	4	100000	26	2026-01-13 01:03:16.19983
961	100	4	108000	38	2026-01-12 21:26:43.824897
962	213	4	40000	44	2026-01-12 20:53:59.853232
963	199	4	40000	36	2026-01-12 20:43:20.632088
964	25	4	88000	45	2026-01-12 20:35:04.401987
965	169	4	88000	11	2026-01-12 20:30:10.054842
966	200	4	40000	40	2026-01-12 14:17:36.717551
967	50	4	112000	41	2026-01-12 13:56:45.213489
968	229	4	48000	12	2026-01-12 13:04:12.282286
969	88	4	100000	42	2026-01-12 09:06:50.353229
970	165	4	88000	43	2026-01-12 08:35:48.339289
971	65	4	120000	49	2026-01-12 08:30:41.74547
972	147	4	88000	19	2026-01-12 04:50:32.539644
973	221	4	40000	28	2026-01-12 03:35:46.168483
974	151	4	88000	35	2026-01-12 03:26:33.217817
975	245	4	48000	28	2026-01-12 01:52:21.807675
976	66	4	100000	2	2026-01-12 01:44:30.580683
977	35	4	100000	33	2026-01-11 23:05:21.72992
978	169	4	88000	11	2026-01-11 20:28:05.801811
979	155	4	88000	3	2026-01-11 20:06:11.117016
980	218	4	40000	16	2026-01-11 17:26:28.485516
981	89	4	100000	46	2026-01-11 15:31:08.72133
982	93	4	108000	10	2026-01-11 15:26:25.317007
983	192	4	40000	8	2026-01-11 14:53:36.679332
984	24	4	88000	41	2026-01-11 13:05:24.215266
985	86	4	100000	34	2026-01-11 11:11:11.136445
986	67	4	100000	10	2026-01-11 08:39:44.853166
987	96	4	108000	22	2026-01-11 05:57:52.087693
988	54	4	120000	5	2026-01-11 04:49:10.529428
989	80	4	100000	10	2026-01-11 03:57:21.028171
990	206	4	40000	16	2026-01-11 01:07:11.403778
991	161	4	88000	27	2026-01-11 01:05:36.241529
992	36	4	100000	37	2026-01-10 23:45:03.48588
993	248	4	48000	40	2026-01-10 23:27:38.523102
994	161	4	88000	27	2026-01-10 22:55:50.742615
995	217	4	40000	12	2026-01-10 15:12:12.693802
996	70	4	100000	22	2026-01-10 15:03:43.827894
997	194	4	40000	16	2026-01-10 14:49:15.888502
998	33	4	100000	25	2026-01-10 13:26:26.084774
999	82	4	100000	18	2026-01-10 13:25:26.007941
1000	167	4	88000	3	2026-01-10 10:31:46.066952
1001	240	4	48000	8	2026-01-10 08:46:21.083338
1002	223	4	40000	36	2026-01-10 06:50:45.098014
1003	34	4	100000	29	2026-01-10 03:25:10.42554
1004	19	4	88000	21	2026-01-10 03:02:26.766113
1005	67	4	100000	10	2026-01-10 02:41:17.531391
1006	242	4	48000	16	2026-01-10 00:30:57.60083
1007	25	4	88000	45	2026-01-09 22:43:12.177637
1008	53	4	120000	1	2026-01-09 20:43:03.53164
1009	94	4	108000	14	2026-01-09 19:54:41.660245
1010	236	4	48000	40	2026-01-09 19:23:56.814406
1011	171	4	88000	19	2026-01-09 16:50:42.233945
1012	130	4	112000	6	2026-01-09 15:31:45.161939
1013	238	4	48000	48	2026-01-09 13:08:48.701871
1014	234	4	48000	32	2026-01-09 12:41:40.106943
1015	90	4	100000	50	2026-01-09 10:08:00.103972
1016	158	4	88000	15	2026-01-09 06:49:41.827762
1017	122	4	112000	22	2026-01-09 06:35:08.968063
1018	91	4	100000	6	2026-01-09 05:22:53.262613
1019	127	4	112000	42	2026-01-09 02:42:40.510712
1020	36	4	100000	37	2026-01-08 22:21:29.68512
1021	219	4	40000	20	2026-01-08 21:54:37.832066
1022	6	4	80000	21	2026-01-08 21:52:29.892728
1023	23	4	88000	37	2026-01-08 21:02:23.284228
1024	1	4	80000	1	2026-01-08 17:37:09.282031
1025	43	4	112000	13	2026-01-08 14:46:11.168511
1026	107	4	108000	14	2026-01-08 13:23:47.22104
1027	79	4	100000	2	2026-01-08 10:00:34.983957
1028	99	4	108000	34	2026-01-08 09:24:28.889991
1029	63	4	120000	41	2026-01-08 08:52:21.605792
1030	228	4	48000	8	2026-01-08 08:13:43.37556
1031	86	4	100000	34	2026-01-08 07:23:30.231217
1032	188	4	100000	39	2026-01-08 07:18:18.725076
1033	77	4	100000	50	2026-01-08 06:59:38.066356
1034	197	4	40000	28	2026-01-08 04:59:22.674693
1035	1	4	80000	1	2026-01-08 03:04:00.51248
1036	208	4	40000	24	2026-01-08 00:05:49.794182
1037	92	4	108000	2	2026-01-07 20:24:16.138096
1038	221	4	40000	28	2026-01-07 14:13:48.450682
1039	133	4	80000	11	2026-01-07 13:30:13.495427
1040	60	4	120000	29	2026-01-07 12:07:20.648637
1041	100	4	108000	38	2026-01-07 11:36:32.822965
1042	71	4	100000	26	2026-01-07 09:33:58.093489
1043	149	4	88000	27	2026-01-07 08:41:41.498439
1044	140	4	80000	39	2026-01-07 07:13:07.050078
1045	64	4	120000	45	2026-01-07 07:01:47.438759
1046	39	4	100000	49	2026-01-07 06:42:32.065866
1047	242	4	48000	16	2026-01-07 04:47:54.636487
1048	184	4	100000	23	2026-01-07 04:02:40.650224
1049	118	4	112000	2	2026-01-07 03:21:57.891519
1050	142	4	80000	47	2026-01-07 02:50:58.426528
1051	157	4	88000	11	2026-01-07 02:41:15.952171
1052	65	4	120000	49	2026-01-07 02:21:39.567835
1053	147	4	88000	19	2026-01-07 02:13:22.65161
1054	92	4	108000	2	2026-01-07 01:03:10.267427
1055	244	5	60000	24	2026-01-06 23:13:44.682096
1056	191	5	50000	4	2026-01-06 22:18:07.263067
1057	247	5	60000	36	2026-01-06 20:58:37.666337
1058	152	5	110000	39	2026-01-06 20:11:47.056567
1059	155	5	110000	3	2026-01-06 18:42:28.05721
1060	27	5	125000	1	2026-01-06 14:11:55.830169
1061	186	5	125000	31	2026-01-06 11:36:39.585211
1062	88	5	125000	42	2026-01-06 11:08:25.912318
1063	152	5	110000	39	2026-01-06 10:06:18.37697
1064	167	5	110000	3	2026-01-06 07:17:14.662748
1065	120	5	140000	14	2026-01-06 06:08:16.819906
1066	204	5	50000	8	2026-01-06 05:29:13.456681
1067	75	5	125000	42	2026-01-06 04:43:58.083432
1068	178	5	110000	47	2026-01-06 01:20:21.553919
1069	101	5	135000	42	2026-01-05 22:40:53.007385
1070	17	5	110000	13	2026-01-05 21:37:33.9294
1071	190	5	125000	47	2026-01-05 21:14:39.334326
1072	63	5	150000	41	2026-01-05 20:22:59.102365
1073	189	5	125000	43	2026-01-05 20:06:19.39296
1074	219	5	50000	20	2026-01-05 17:30:19.668759
1075	176	5	110000	39	2026-01-05 16:56:01.038185
1076	91	5	125000	6	2026-01-05 16:50:53.251483
1077	158	5	110000	15	2026-01-05 15:20:46.915081
1078	138	5	100000	31	2026-01-05 12:16:54.406736
1079	170	5	110000	15	2026-01-05 09:09:01.696285
1080	142	5	100000	47	2026-01-05 06:38:03.656991
1081	7	5	100000	25	2026-01-05 05:13:18.558015
1082	204	5	50000	8	2026-01-05 04:25:07.243191
1083	250	5	60000	48	2026-01-04 22:19:58.876041
1084	134	5	100000	15	2026-01-04 20:34:19.505837
1085	202	5	50000	48	2026-01-04 19:47:15.782376
1086	13	5	100000	49	2026-01-04 18:12:33.39189
1087	243	5	60000	20	2026-01-04 14:07:10.744929
1088	5	5	100000	17	2026-01-04 13:43:16.953289
1089	8	5	100000	29	2026-01-04 13:43:13.57884
1090	140	5	100000	39	2026-01-04 13:40:41.017527
1091	164	5	110000	39	2026-01-04 13:25:03.018005
1092	21	5	110000	29	2026-01-04 12:19:33.544789
1093	141	5	100000	43	2026-01-04 11:49:24.900526
1094	37	5	125000	41	2026-01-04 11:32:42.663133
1095	78	5	125000	6	2026-01-04 09:16:26.353229
1096	216	5	50000	8	2026-01-04 07:20:01.423757
1097	52	5	140000	49	2026-01-04 05:34:37.115726
1098	113	5	135000	38	2026-01-04 05:21:55.518589
1099	80	5	125000	10	2026-01-04 04:17:58.356788
1100	220	5	50000	24	2026-01-04 04:17:40.165853
1101	15	5	110000	5	2026-01-04 02:38:04.03252
1102	81	5	125000	14	2026-01-03 23:00:59.337366
1103	75	5	125000	42	2026-01-03 22:06:16.650492
1104	84	5	125000	26	2026-01-03 21:57:05.678582
1105	35	5	125000	33	2026-01-03 21:47:55.992924
1106	156	5	110000	7	2026-01-03 20:15:07.133382
1107	79	5	125000	2	2026-01-03 17:54:21.685541
1108	36	5	125000	37	2026-01-03 16:32:40.583623
1109	73	5	125000	34	2026-01-03 16:06:52.460225
1110	185	5	125000	27	2026-01-03 15:23:06.036937
1111	129	5	140000	50	2026-01-03 13:28:56.868038
1112	5	5	100000	17	2026-01-03 12:30:51.392597
1113	112	5	135000	34	2026-01-03 11:59:55.813542
1114	139	5	100000	35	2026-01-03 11:55:34.630085
1115	155	5	110000	3	2026-01-03 09:41:37.480953
1116	33	5	125000	25	2026-01-03 06:52:26.219144
1117	176	5	110000	39	2026-01-03 06:38:42.08928
1118	15	5	110000	5	2026-01-03 02:52:54.779519
1119	190	5	125000	47	2026-01-03 02:00:03.240095
1120	178	5	110000	47	2026-01-03 01:35:24.973686
1121	213	5	50000	44	2026-01-02 23:46:23.158446
1122	170	5	110000	15	2026-01-02 17:02:48.645168
1123	82	5	125000	18	2026-01-02 16:43:05.982399
1124	227	5	60000	4	2026-01-02 14:12:17.993476
1125	144	5	110000	7	2026-01-02 11:48:11.718949
1126	126	5	140000	38	2026-01-02 07:10:32.046234
1127	68	5	125000	14	2026-01-02 06:50:34.985821
1128	3	5	100000	9	2026-01-02 05:53:25.634486
1129	47	5	140000	29	2026-01-02 05:34:00.655626
1130	33	5	125000	25	2026-01-02 05:04:06.056525
1131	140	5	100000	39	2026-01-02 04:30:51.361477
1132	193	5	50000	12	2026-01-02 04:28:51.192857
1133	93	5	135000	10	2026-01-02 01:03:08.183396
1134	22	5	110000	33	2026-01-02 00:28:27.22598
1135	161	5	110000	27	2026-01-01 21:48:22.742366
1136	148	5	110000	23	2026-01-01 20:09:21.351064
1137	185	5	125000	27	2026-01-01 19:22:46.137895
1138	92	5	135000	2	2026-01-01 19:04:13.353198
1139	196	5	50000	24	2026-01-01 19:00:13.935323
1140	65	5	150000	49	2026-01-01 16:40:57.631104
1141	79	5	125000	2	2026-01-01 15:48:21.961769
1142	228	5	60000	8	2026-01-01 15:45:17.928399
1143	27	5	125000	1	2026-01-01 12:01:30.744131
1144	59	5	150000	25	2026-01-01 11:21:28.784666
1145	245	5	60000	28	2026-01-01 06:48:53.881766
1146	174	5	110000	31	2026-01-01 06:44:13.372534
1147	173	5	110000	27	2026-01-01 05:45:40.317787
1148	11	5	100000	41	2026-01-01 03:14:57.053456
1149	110	5	135000	26	2026-01-01 02:42:21.357063
1150	168	5	110000	7	2026-01-01 01:34:05.860501
1151	68	5	125000	14	2026-01-01 01:16:02.374588
1152	155	5	110000	3	2025-12-31 22:35:46.218372
1153	151	5	110000	35	2025-12-31 22:26:42.512088
1154	209	5	50000	28	2025-12-31 20:56:44.009003
1155	5	5	100000	17	2025-12-31 19:24:12.860952
1156	120	5	140000	14	2025-12-31 15:38:23.779006
1157	239	5	60000	4	2025-12-31 14:32:08.287879
1158	9	5	100000	33	2025-12-31 11:48:48.343877
1159	110	5	135000	26	2025-12-31 11:22:49.527807
1160	90	5	125000	50	2025-12-31 08:17:07.32295
1161	87	5	125000	38	2025-12-31 04:44:01.211697
1162	133	5	100000	11	2025-12-31 03:42:31.411828
1163	167	5	110000	3	2025-12-31 03:24:20.13
1164	103	5	135000	50	2025-12-31 03:18:26.048015
1165	101	5	135000	42	2025-12-31 03:16:13.026376
1166	193	5	50000	12	2025-12-31 01:43:47.429352
1167	129	5	140000	50	2025-12-31 01:12:10.899464
1168	209	5	50000	28	2025-12-30 23:23:27.94801
1169	248	5	60000	40	2025-12-30 23:06:02.331173
1170	14	5	110000	1	2025-12-30 22:45:39.440226
1171	76	5	125000	46	2025-12-30 21:44:42.492212
1172	49	5	140000	37	2025-12-30 21:40:55.066533
1173	246	5	60000	32	2025-12-30 20:21:17.551562
1174	147	5	110000	19	2025-12-30 18:33:19.955303
1175	96	5	135000	22	2025-12-30 16:13:51.438988
1176	225	5	50000	44	2025-12-30 16:11:32.606973
1177	201	5	50000	44	2025-12-30 14:36:54.532578
1178	245	5	60000	28	2025-12-30 14:10:24.409394
1179	7	5	100000	25	2025-12-30 14:07:10.909268
1180	73	5	125000	34	2025-12-30 10:35:53.194637
1181	181	5	125000	11	2025-12-30 10:23:44.192315
1182	81	5	125000	14	2025-12-30 10:11:38.771483
1183	68	5	125000	14	2025-12-30 08:45:31.619575
1184	51	5	140000	45	2025-12-30 08:08:19.036911
1185	17	5	110000	13	2025-12-30 07:17:34.519453
1186	123	5	140000	26	2025-12-30 07:07:59.922263
1187	126	5	140000	38	2025-12-30 05:53:26.704383
1188	240	5	60000	8	2025-12-30 04:11:41.381357
1189	46	5	140000	25	2025-12-29 20:30:06.010958
1190	187	5	125000	35	2025-12-29 16:40:18.936851
1191	71	5	125000	26	2025-12-29 14:42:33.000097
1192	7	5	100000	25	2025-12-29 13:42:31.507143
1193	195	5	50000	20	2025-12-29 12:02:19.879804
1194	126	5	140000	38	2025-12-29 10:43:16.025771
1195	116	5	135000	50	2025-12-29 09:33:20.643117
1196	198	5	50000	32	2025-12-29 09:03:24.522359
1197	146	5	110000	15	2025-12-29 06:48:21.436318
1198	197	5	50000	28	2025-12-29 05:49:45.012999
1199	197	5	50000	28	2025-12-29 04:10:21.136849
1200	115	5	135000	46	2025-12-29 01:04:26.79293
1201	216	5	50000	8	2025-12-29 00:51:54.546066
1202	85	5	125000	30	2025-12-29 00:32:17.683172
1203	2	5	100000	5	2025-12-28 22:26:33.690527
1204	186	5	125000	31	2025-12-28 22:01:00.368886
1205	205	5	50000	12	2025-12-28 21:37:54.280193
1206	223	5	50000	36	2025-12-28 21:31:45.692166
1207	14	5	110000	1	2025-12-28 18:53:51.169456
1208	167	5	110000	3	2025-12-28 18:48:09.758972
1209	215	5	50000	4	2025-12-28 17:34:06.636588
1210	154	5	110000	47	2025-12-28 17:19:10.421551
1211	107	5	135000	14	2025-12-28 15:40:01.043224
1212	41	5	140000	5	2025-12-28 15:39:43.797531
1213	108	5	135000	18	2025-12-28 15:32:03.964814
1214	55	5	150000	9	2025-12-28 14:34:23.964774
1215	131	5	100000	3	2025-12-28 12:17:53.093884
1216	31	5	125000	17	2025-12-28 11:49:41.468035
1217	244	5	60000	24	2025-12-28 11:20:48.045269
1218	158	5	110000	15	2025-12-28 08:07:23.734555
1219	172	5	110000	23	2025-12-28 05:46:33.690992
1220	109	5	135000	22	2025-12-28 05:34:30.544808
1221	8	5	100000	29	2025-12-28 03:52:20.583204
1222	146	5	110000	15	2025-12-28 03:45:01.460456
1223	227	5	60000	4	2025-12-28 02:59:33.992816
1224	13	5	100000	49	2025-12-28 00:25:49.788614
1225	183	5	125000	19	2025-12-27 23:54:04.698103
1226	175	5	110000	35	2025-12-27 23:15:50.845163
1227	24	5	110000	41	2025-12-27 20:28:08.450936
1228	150	5	110000	31	2025-12-27 19:25:35.161559
1229	27	5	125000	1	2025-12-27 18:35:03.878258
1230	170	5	110000	15	2025-12-27 16:48:51.510822
1231	235	5	60000	36	2025-12-27 15:38:41.654636
1232	140	5	100000	39	2025-12-27 13:30:08.137274
1233	132	5	100000	7	2025-12-27 13:21:16.694261
1234	135	5	100000	19	2025-12-27 13:01:19.519989
1235	34	5	125000	29	2025-12-27 12:36:40.129691
1236	12	5	100000	45	2025-12-27 10:36:44.130543
1237	241	5	60000	12	2025-12-27 08:50:13.781412
1238	64	5	150000	45	2025-12-27 04:33:08.190155
1239	1	5	100000	1	2025-12-27 04:30:27.835847
1240	181	5	125000	11	2025-12-27 04:06:16.53859
1241	230	5	60000	16	2025-12-27 03:32:37.624204
1242	175	5	110000	35	2025-12-27 03:18:00.066962
1243	19	5	110000	21	2025-12-27 02:12:00.960235
1244	115	5	135000	46	2025-12-27 02:10:22.743568
1245	175	5	110000	35	2025-12-27 00:39:51.682705
1246	106	5	135000	10	2025-12-26 22:23:51.611545
1247	197	5	50000	28	2025-12-26 19:00:15.563489
1248	83	5	125000	22	2025-12-26 18:56:31.290274
1249	244	5	60000	24	2025-12-26 18:42:23.906793
1250	234	5	60000	32	2025-12-26 18:12:39.440616
1251	1	1	20000	1	2026-03-26 21:01:54.632439
1252	1	3	60000	1	2026-03-26 21:05:00.172196
1253	1	1	20000	1	2026-03-26 21:12:13.634382
1254	1	1	20000	1	2026-03-26 21:17:05.007782
1255	14	1	22000	1	2026-03-26 21:17:05.018985
1256	27	11	275000	1	2026-03-26 21:28:49.511214
1257	40	1	28000	1	2026-03-26 21:29:38.78063
1258	53	1	30000	1	2026-03-26 21:29:49.317442
1259	14	1	22000	1	2026-03-26 21:30:20.811627
1260	40	1	28000	1	2026-03-26 21:30:32.024164
1261	40	11	308000	1	2026-03-26 21:30:41.835249
1262	1	11	220000	1	2026-03-26 21:31:01.682428
1263	40	1	28000	1	2026-03-26 21:34:29.211566
1264	40	11	308000	1	2026-03-26 22:06:35.545611
1265	2	1	20000	5	2026-03-27 01:52:32.452048
1266	3	11	220000	9	2026-03-27 01:53:50.317468
1267	16	1	22000	9	2026-03-27 01:55:59.762398
1268	16	9	198000	9	2026-03-27 01:56:19.076272
1269	16	2	44000	9	2026-03-27 01:56:35.935681
1270	15	11	242000	5	2026-03-27 02:02:03.165482
1271	4	10	200000	13	2026-03-27 02:02:49.778106
1272	28	5	125000	5	2026-03-27 02:03:41.495234
1273	41	2	56000	5	2026-03-27 02:04:04.516909
1274	17	1	22000	13	2026-03-27 02:41:53.935459
1275	30	1	25000	13	2026-03-27 02:42:01.042502
1276	53	1	30000	1	2026-03-27 02:42:15.795966
1277	40	1	28000	1	2026-03-27 02:43:28.661386
1278	40	1	28000	1	2026-03-27 02:43:42.114216
1279	43	9	252000	13	2026-03-27 02:54:31.879619
\.


--
-- TOC entry 3373 (class 0 OID 39693)
-- Dependencies: 223
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, password, role, created_at) FROM stdin;
\.


--
-- TOC entry 3384 (class 0 OID 0)
-- Dependencies: 220
-- Name: logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.logs_id_seq', 39, true);


--
-- TOC entry 3385 (class 0 OID 0)
-- Dependencies: 214
-- Name: machines_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.machines_id_seq', 51, true);


--
-- TOC entry 3386 (class 0 OID 0)
-- Dependencies: 216
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_id_seq', 252, true);


--
-- TOC entry 3387 (class 0 OID 0)
-- Dependencies: 218
-- Name: sales_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sales_id_seq', 1279, true);


--
-- TOC entry 3388 (class 0 OID 0)
-- Dependencies: 222
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- TOC entry 3213 (class 2606 OID 39686)
-- Name: logs logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (id);


--
-- TOC entry 3207 (class 2606 OID 39642)
-- Name: machines machines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.machines
    ADD CONSTRAINT machines_pkey PRIMARY KEY (id);


--
-- TOC entry 3209 (class 2606 OID 39653)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- TOC entry 3211 (class 2606 OID 39666)
-- Name: sales sales_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_pkey PRIMARY KEY (id);


--
-- TOC entry 3215 (class 2606 OID 39700)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3217 (class 2606 OID 39702)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 3221 (class 2606 OID 39687)
-- Name: logs logs_machine_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_machine_id_fkey FOREIGN KEY (machine_id) REFERENCES public.machines(id);


--
-- TOC entry 3218 (class 2606 OID 39654)
-- Name: products products_machine_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_machine_id_fkey FOREIGN KEY (machine_id) REFERENCES public.machines(id) ON DELETE CASCADE;


--
-- TOC entry 3219 (class 2606 OID 39672)
-- Name: sales sales_machine_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_machine_id_fkey FOREIGN KEY (machine_id) REFERENCES public.machines(id);


--
-- TOC entry 3220 (class 2606 OID 39667)
-- Name: sales sales_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


-- Completed on 2026-04-12 23:16:50

--
-- PostgreSQL database dump complete
--

\unrestrict FUbImmHr5nCq8jQqkBFfULg1URrcNRJeFTRDN0Bdd6cYx2eBixwHSPS6L9ecdYK

