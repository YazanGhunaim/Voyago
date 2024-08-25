"""create users table

Revision ID: 45c7b47dcd99
Revises: 
Create Date: 2024-08-25 20:04:47.403047

"""
import sqlalchemy as sa
from alembic import op

# revision identifiers, used by Alembic.
revision = '45c7b47dcd99'
down_revision = None
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.create_table("users",
                    sa.Column("id", sa.Integer(), primary_key=True, nullable=False),
                    sa.Column("first_name", sa.String(), nullable=False),
                    sa.Column("last_name", sa.String(), nullable=False),
                    sa.Column("username", sa.String(), unique=True, nullable=False),
                    sa.Column("email", sa.String(), unique=True, nullable=False),
                    sa.Column("password", sa.String(), nullable=False),
                    sa.Column("created_at", sa.TIMESTAMP(), server_default=sa.text("now()"), nullable=False),
                    )


def downgrade() -> None:
    op.drop_table("users")
