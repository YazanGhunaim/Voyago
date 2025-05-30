create
or replace function public.handle_new_user()
    returns trigger as $$
begin
insert into public.users (id, email, name, username, profile_pic, bio, location)
values (new.id,
        new.email,
        new.raw_user_meta_data ->>'name',
        new.raw_user_meta_data ->>'username',
        new.raw_user_meta_data ->>'profile_pic',
        new.raw_user_meta_data ->>'bio',
        new.raw_user_meta_data -> 'location');
return new;
end;
$$
language plpgsql security definer;

create
or replace trigger on_auth_user_created
    after insert
    on auth.users
    for each row execute procedure public.handle_new_user();
