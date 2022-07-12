
-- use this script when all the base tables in this script are loaded.
CREATE MATERIALIZED VIEW MV_ALL_LINKS AS 
SELECT * FROM MV_INSTANCE_HYPONYM 
union 
SELECT * FROM MV_PART_HOLONYM
union
SELECT * FROM MV_PART_MERONYM
union 
SELECT * FROM MV_MEMBER_MERONYM
union 
SELECT * FROM MV_DERIVATION
union
select * from MV_DIRECT_HYPONYM
union
select * from MV_SUBSTANCE_MERONYM
union
select * from MV_DIRECT_HYPERNYM
union
select * from MV_ANTONYM
union
select * from MV_SIMILAR_TO
union
select * from MV_DOMAIN_CATEGORY
union
select * from MV_MEMBER_HOLONYM
union
select * from MV_SUBSTANCE_HOLONYM 
union
select * from MV_ENTAILMENT
union
select * from MV_CAUSE
union
select * from MV_ALSO 
union
select * from MV_ATTRIBUTE
union
select * from MV_VERB_GROUP
union
select * from MV_PARTICIPLE
union
select * from MV_PERTAINYM
union
select * from MV_INSTANCE_HYPERNYM
union
select * from MV_DOMAIN_MEMBER_CATEGORY
union
select * from MV_DOMAIN_REGION
union
select * from MV_DOMAIN_MEMBER_USAGE
union
select * from MV_DOMAIN_USAGE
union
select * from MV_DOMAIN_MEMBER_REGION
union
select * from mv_has_instance_hyponym
union
select * from MV_PHRASAL_VERB;



--------------------------------------------------------
--  DDL for Function SF_CNT_IN_SET_RATIO
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SF_CNT_IN_SET_RATIO" (
  in_string in varchar2,
  set_belong in varchar2) return number
--- select sf_cnt_in_set_ratio( 'abecd', 'aeiouAEIOU ') from dual;
-- return 0.4
-- the higher the ratio the more vowels thus easier words to guess in hangman
 
is
	white_char varchar2(100) := ' -/.''';
	str_len number := 0;
  cnt number := 0;
  in_char char(1);
  in_length number;
  cnt_belong number;
  res number;
begin
  in_length := length(in_string);
  cnt_belong := 0;
  while (cnt < in_length)
  loop
    cnt := cnt + 1;
    in_char := substr(in_string, cnt, 1);
    if instr(white_char, in_char) = 0 then 
       str_len := str_len + 1; 
       if instr(set_belong, in_char) <> 0 then cnt_belong := cnt_belong + 1; end if;
    end if;
  end loop;
  res := cnt_belong/str_len;
  return res;
 end;
/
--------------------------------------------------------
--  DDL for Function SF_CNT_NOT_IN_SET_CONSECUTIVE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SF_CNT_NOT_IN_SET_CONSECUTIVE" (
  in_string in varchar2,
  set_belong in varchar2) return number
  --- select sf_cnt_not_in_set_consecutive( 'abecdfgha', 'aeiouAEIOU-/.'' ') from dual;
  --- returns 5
is
  max_seq_not_belong number := 0;
  seq_not_belong number := 0;
  in_length number;
  cnt number := 0;
  in_char char(1);
  res number;
begin
  in_length := length(in_string);
  while (cnt < in_length)
  loop
    cnt := cnt + 1;
    in_char := substr(in_string, cnt, 1);
    if instr(set_belong, in_char) = 0 then 
       seq_not_belong := seq_not_belong + 1; 
    else
       if seq_not_belong >= max_seq_not_belong then 
            max_seq_not_belong := seq_not_belong; end if;
      seq_not_belong := 0;
    end if;
  end loop;
  
  if seq_not_belong >= max_seq_not_belong then 
            max_seq_not_belong := seq_not_belong; end if;
   res := max_seq_not_belong;
   return res;
 end;
/
--------------------------------------------------------
--  DDL for Function SF_EXCLUDING_CHARS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SF_EXCLUDING_CHARS" (
  in_string in varchar2,
  in_excluded_char in varchar2) return number
--- return
-- 0 if string has excluded characters
---1 otherwise
-- select sf_excluding_chars('abcd', '0123456789') from dual;
-- should return 0
 
is
	in_length number;
	str_len number := 0;
  cnt number := 0;
  in_char char(1);
  res integer := 1;
begin
  in_length := length(in_string);
  while (cnt < in_length and res = 1 )
  loop
    cnt := cnt + 1;
    in_char := substr(in_string, cnt, 1);
    if instr(in_excluded_char, in_char) <> 0 then 
       res := 0;
    end if;
  end loop;
 return res;
 end;
/
--------------------------------------------------------
--  DDL for Function SF_STR_LEN
--------------------------------------------------------

create or replace
function sf_str_len (
  in_string in varchar2) return number
-- get the length of string excluding space, - / . '
is
	white_char varchar2(100) := ' -/.''';
	in_length number;
	str_len number := 0;
  cnt number := 0;
  in_char char(1);
  res number;
begin
  in_length := length(in_string);
  while (cnt < in_length)
  loop
    cnt := cnt + 1;
    in_char := substr(in_string, cnt, 1);
    if instr(white_char, in_char) = 0 then 
       str_len := str_len + 1; 
    end if;
  end loop;
  res := str_len;
  return res;
 end;
/
