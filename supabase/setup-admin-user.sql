-- ====================================
-- 設定管理員使用者
-- ====================================

-- 方法 1: 如果您知道管理員的 email
-- 將 'your-admin-email@example.com' 替換為實際的管理員 email
-- 注意：使用 raw_app_meta_data（而非 raw_user_meta_data）因為 app_metadata 不可被用戶自行修改

UPDATE auth.users 
SET raw_app_meta_data = jsonb_set(
  COALESCE(raw_app_meta_data, '{}'::jsonb),
  '{role}',
  '"admin"'
)
WHERE email = 'your-admin-email@example.com';

-- ====================================
-- 方法 2: 如果您知道管理員的 user ID
-- 將 'user-uuid-here' 替換為實際的 user ID
-- ====================================

-- UPDATE auth.users 
-- SET raw_app_meta_data = jsonb_set(
--   COALESCE(raw_app_meta_data, '{}'::jsonb),
--   '{role}',
--   '"admin"'
-- )
-- WHERE id = 'user-uuid-here'::uuid;

-- ====================================
-- 方法 3: 查看所有使用者並手動設定
-- ====================================

-- 先查看所有使用者
SELECT 
    id,
    email,
    created_at,
    raw_app_meta_data->>'role' as current_role
FROM auth.users
ORDER BY created_at DESC;

-- 然後根據上面的結果，使用方法 1 或 2 設定管理員角色

-- ====================================
-- 驗證設定是否成功
-- ====================================

SELECT 
    id,
    email,
    raw_app_meta_data->>'role' as role,
    created_at
FROM auth.users
WHERE raw_app_meta_data->>'role' = 'admin';

-- 應該會看到您設定的管理員帳號

-- ====================================
-- 注意事項
-- ====================================

-- 1. 執行此腳本前，請確保您已經在 Supabase Auth 中註冊了帳號
-- 2. 建議至少設定一個管理員帳號
-- 3. 不要將所有帳號都設為管理員
-- 4. 管理員帳號應該使用強密碼並啟用 2FA（如果可用）
