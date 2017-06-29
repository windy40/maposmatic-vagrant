--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.6
-- Dumped by pg_dump version 9.5.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: contours; Type: DATABASE; Schema: -; Owner: maposmatic
--
 
CREATE DATABASE contours WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';


ALTER DATABASE contours OWNER TO maposmatic;

\connect contours
 
SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


SET search_path = public, pg_catalog;
 
SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: contours; Type: TABLE; Schema: public; Owner: maposmatic
--

CREATE TABLE contours (
    gid integer NOT NULL,
    id integer,
    height double precision,
    wkb_geometry geometry(MultiLineString,3857)
);

 
ALTER TABLE contours OWNER TO maposmatic;

--
-- Name: contour_gid_seq; Type: SEQUENCE; Schema: public; Owner: maposmatic
--

CREATE SEQUENCE contour_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 

ALTER TABLE contour_gid_seq OWNER TO maposmatic;
 
--
-- Name: contour_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: maposmatic
--
 
ALTER SEQUENCE contour_gid_seq OWNED BY contours.gid;


--
-- Name: gid; Type: DEFAULT; Schema: public; Owner: maposmatic
--

ALTER TABLE ONLY contours ALTER COLUMN gid SET DEFAULT nextval('contour_gid_seq'::regclass);

 
--
-- Name: contour_pkey; Type: CONSTRAINT; Schema: public; Owner: maposmatic
--
 
ALTER TABLE ONLY contours
    ADD CONSTRAINT contour_pkey PRIMARY KEY (gid);
 
 
--
-- Name: contour_geom_idx; Type: INDEX; Schema: public; Owner: maposmatic
--
 
CREATE INDEX contour_geom_idx ON contours USING gist (wkb_geometry);
 
 
--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--
 
REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;
 
 
--
-- PostgreSQL database dump complete
--
 

