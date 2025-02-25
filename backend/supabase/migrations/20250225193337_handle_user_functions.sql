set
check_function_bodies = off;

CREATE
OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
begin
insert into public.users (id, email, name, username, profile_pic, bio, location)
values (new.id,
        new.email,
        new.raw_user_meta_data ->>'name',
        new.raw_user_meta_data ->>'username',
        new.raw_user_meta_data ->>'profile_pic',
        new.raw_user_meta_data ->>'bio',
        new.raw_user_meta_data - > 'location');
return new;
end;
$function$
;

CREATE
OR REPLACE FUNCTION public.handle_user_update()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
begin
insert into public.users (id, email, name, username, profile_pic, bio, location)
values (new.id,
        new.email,
        new.raw_user_meta_data ->> 'name',
        new.raw_user_meta_data ->> 'username',
        new.raw_user_meta_data ->> 'profile_pic',
        new.raw_user_meta_data ->> 'bio',
        new.raw_user_meta_data - > 'location') on conflict (id)
    do
update set
    email = excluded.email,
    name = excluded.name,
    username = excluded.username,
    profile_pic = excluded.profile_pic,
    bio = excluded.bio,
    location = excluded.location;

return new;
end;
$function$
;