/**
 * Initial schema — see docs/prototype-reference and the project plan for the
 * rationale (hybrid: relational for anything with a lifecycle/user
 * relationship, flat bilingual tables for read-mostly editorial content).
 * @param pgm {import('node-pg-migrate').MigrationBuilder}
 */
exports.up = (pgm) => {
  pgm.createExtension('pgcrypto', { ifNotExists: true });

  pgm.createTable('users', {
    id: { type: 'uuid', primaryKey: true, default: pgm.func('gen_random_uuid()') },
    phone: { type: 'varchar(10)', notNull: true, unique: true },
    name: { type: 'varchar(120)' },
    role: { type: 'varchar(20)', notNull: true, default: 'citizen' }, // 'citizen' | 'officer'
    created_at: { type: 'timestamptz', notNull: true, default: pgm.func('now()') },
    last_login_at: { type: 'timestamptz' },
  });

  pgm.createTable('otp_codes', {
    id: { type: 'uuid', primaryKey: true, default: pgm.func('gen_random_uuid()') },
    phone: { type: 'varchar(10)', notNull: true },
    code: { type: 'varchar(6)', notNull: true },
    purpose: { type: 'varchar(20)', notNull: true, default: 'login' },
    expires_at: { type: 'timestamptz', notNull: true },
    consumed_at: { type: 'timestamptz' },
    attempt_count: { type: 'integer', notNull: true, default: 0 },
    created_at: { type: 'timestamptz', notNull: true, default: pgm.func('now()') },
  });
  pgm.createIndex('otp_codes', ['phone', 'consumed_at']);

  pgm.createTable('complaints', {
    id: { type: 'uuid', primaryKey: true, default: pgm.func('gen_random_uuid()') },
    ticket_id: { type: 'varchar(20)', notNull: true, unique: true },
    citizen_id: { type: 'uuid', notNull: true, references: 'users', onDelete: 'CASCADE' },
    full_name: { type: 'varchar(120)', notNull: true },
    mobile: { type: 'varchar(10)', notNull: true },
    category: { type: 'varchar(30)', notNull: true }, // documents|education|schemeDelay|corruption|other
    description: { type: 'text', notNull: true },
    attachment_path: { type: 'varchar(255)' },
    status: { type: 'varchar(30)', notNull: true, default: 'underReview' },
    rejection_reason: { type: 'text' },
    verdict_file_path: { type: 'varchar(255)' },
    assigned_officer_id: { type: 'uuid', references: 'users' },
    created_at: { type: 'timestamptz', notNull: true, default: pgm.func('now()') },
    updated_at: { type: 'timestamptz', notNull: true, default: pgm.func('now()') },
  });

  pgm.createTable('complaint_status_history', {
    id: { type: 'uuid', primaryKey: true, default: pgm.func('gen_random_uuid()') },
    complaint_id: { type: 'uuid', notNull: true, references: 'complaints', onDelete: 'CASCADE' },
    status: { type: 'varchar(30)', notNull: true },
    note: { type: 'text' },
    changed_by: { type: 'uuid', references: 'users' },
    created_at: { type: 'timestamptz', notNull: true, default: pgm.func('now()') },
  });
  pgm.createIndex('complaint_status_history', 'complaint_id');

  pgm.createTable('hearings', {
    id: { type: 'uuid', primaryKey: true, default: pgm.func('gen_random_uuid()') },
    complaint_id: { type: 'uuid', notNull: true, references: 'complaints', onDelete: 'CASCADE' },
    kind: { type: 'varchar(10)', notNull: true }, // 'first' | 'final'
    scheduled_date: { type: 'date', notNull: true },
    scheduled_time: { type: 'varchar(10)', notNull: true },
    location: { type: 'varchar(200)', notNull: true },
    officer_name: { type: 'varchar(120)', notNull: true },
    created_at: { type: 'timestamptz', notNull: true, default: pgm.func('now()') },
  });
  pgm.createIndex('hearings', 'complaint_id');

  pgm.createTable('feedback', {
    id: { type: 'uuid', primaryKey: true, default: pgm.func('gen_random_uuid()') },
    user_id: { type: 'uuid', references: 'users' },
    name: { type: 'varchar(120)' },
    rating: { type: 'smallint', notNull: true, check: 'rating BETWEEN 1 AND 5' },
    message: { type: 'text', notNull: true },
    created_at: { type: 'timestamptz', notNull: true, default: pgm.func('now()') },
  });

  // --- Content tables: flat bilingual columns, seeded from prototype T objects (see seeds/seed-content.js) ---

  pgm.createTable('schemes_categories', {
    id: 'id',
    key: { type: 'varchar(30)', notNull: true, unique: true },
    title_en: { type: 'text', notNull: true },
    title_mr: { type: 'text', notNull: true },
    icon_key: { type: 'varchar(30)' },
    tint: { type: 'varchar(10)' },
    item_count: { type: 'integer', default: 0 },
    sort_order: { type: 'integer', default: 0 },
  });

  pgm.createTable('documents', {
    id: 'id',
    title_en: { type: 'text', notNull: true },
    title_mr: { type: 'text', notNull: true },
    category: { type: 'varchar(30)' },
    meta_en: { type: 'text' },
    meta_mr: { type: 'text' },
    tint: { type: 'varchar(10)' },
    file_path: { type: 'varchar(255)' },
    sort_order: { type: 'integer', default: 0 },
  });

  pgm.createTable('initiatives', {
    id: 'id',
    title_en: { type: 'text', notNull: true },
    title_mr: { type: 'text', notNull: true },
    district_en: { type: 'text' },
    district_mr: { type: 'text' },
    description_en: { type: 'text' },
    description_mr: { type: 'text' },
    image_path: { type: 'varchar(255)' },
    sort_order: { type: 'integer', default: 0 },
  });

  pgm.createTable('news_items', {
    id: 'id',
    tag: { type: 'varchar(30)' },
    title_en: { type: 'text', notNull: true },
    title_mr: { type: 'text', notNull: true },
    snippet_en: { type: 'text' },
    snippet_mr: { type: 'text' },
    published_date: { type: 'date' },
    sort_order: { type: 'integer', default: 0 },
  });

  pgm.createTable('education_items', {
    id: 'id',
    title_en: { type: 'text', notNull: true },
    title_mr: { type: 'text', notNull: true },
    desc_en: { type: 'text' },
    desc_mr: { type: 'text' },
    sort_order: { type: 'integer', default: 0 },
  });

  pgm.createTable('pm_scheme_points', {
    id: 'id',
    point_number: { type: 'smallint', notNull: true },
    title_en: { type: 'text', notNull: true },
    title_mr: { type: 'text', notNull: true },
    collapsed_summary_en: { type: 'text' },
    collapsed_summary_mr: { type: 'text' },
    detail_en: { type: 'text' },
    detail_mr: { type: 'text' },
  });

  pgm.createTable('commission_members', {
    id: 'id',
    name: { type: 'text', notNull: true },
    role_en: { type: 'text' },
    role_mr: { type: 'text' },
    initials: { type: 'varchar(4)' },
    is_leadership: { type: 'boolean', notNull: true, default: false },
    sort_order: { type: 'integer', default: 0 },
  });
};

/**
 * @param pgm {import('node-pg-migrate').MigrationBuilder}
 */
exports.down = (pgm) => {
  pgm.dropTable('commission_members');
  pgm.dropTable('pm_scheme_points');
  pgm.dropTable('education_items');
  pgm.dropTable('news_items');
  pgm.dropTable('initiatives');
  pgm.dropTable('documents');
  pgm.dropTable('schemes_categories');
  pgm.dropTable('feedback');
  pgm.dropTable('hearings');
  pgm.dropTable('complaint_status_history');
  pgm.dropTable('complaints');
  pgm.dropTable('otp_codes');
  pgm.dropTable('users');
};
