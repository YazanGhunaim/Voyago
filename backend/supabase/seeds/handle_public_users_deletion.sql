-- Function to delete user from auth.users when deleted from public.users
-- CREATE
-- OR REPLACE FUNCTION public.handle_user_deletion()
--     RETURNS TRIGGER AS $$
-- BEGIN
-- DELETE
-- FROM auth.users
-- WHERE id = OLD.id;
-- RETURN OLD;
-- END;
-- $$
-- LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to call the function after a row is deleted from public.users
CREATE
OR REPLACE TRIGGER on_public_user_deleted
    AFTER DELETE
ON public.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_user_deletion();