"""empty message

Revision ID: d611f88dafb2
Revises: 4b4823a384e7
Create Date: 2023-03-03 15:05:29.932888

"""
from alembic import op
import sqlalchemy as sa
from datetime import datetime, timezone
from app.helpers.db_set_type import DbSetType

DeclarativeBase = sa.orm.declarative_base()

# revision identifiers, used by Alembic.
revision = 'd611f88dafb2'
down_revision = '4b4823a384e7'
branch_labels = None
depends_on = None


class Recipe(DeclarativeBase):
    __tablename__ = 'recipe'
    id = sa.Column(sa.Integer, primary_key=True)
    planned = sa.Column(sa.Boolean)
    planned_days = sa.Column(DbSetType(), default=set())


class Planner(DeclarativeBase):
    __tablename__ = 'planner'
    recipe_id = sa.Column(sa.Integer, sa.ForeignKey(
        'recipe.id'), primary_key=True)
    day = sa.Column(sa.Integer, primary_key=True)
    yields = sa.Column(sa.Integer)
    created_at = sa.Column(sa.DateTime, nullable=False)
    updated_at = sa.Column(sa.DateTime, nullable=False)


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('planner',
    sa.Column('recipe_id', sa.Integer(), nullable=False),
    sa.Column('day', sa.Integer(), nullable=False),
    sa.Column('yields', sa.Integer(), nullable=True),
    sa.Column('created_at', sa.DateTime(), nullable=False),
    sa.Column('updated_at', sa.DateTime(), nullable=False),
    sa.ForeignKeyConstraint(['recipe_id'], ['recipe.id'], name=op.f('fk_planner_recipe_id_recipe')),
    sa.PrimaryKeyConstraint('recipe_id', 'day', name=op.f('pk_planner'))
    )

    # Data migration
    bind = op.get_bind()
    session = sa.orm.Session(bind=bind)
    plans = []
    for recipe in session.query(Recipe).all():
        if recipe.planned:
            if len(recipe.planned_days) > 0:
                for day in recipe.planned_days:
                    p = Planner()
                    p.recipe_id = recipe.id
                    p.day = day
                    p.created_at = datetime.now(timezone.utc)
                    p.updated_at = datetime.now(timezone.utc)
                    plans.append(p)
            else:
                p = Planner()
                p.recipe_id = recipe.id
                p.day = -1
                p.created_at = datetime.now(timezone.utc)
                p.updated_at = datetime.now(timezone.utc)
                plans.append(p)

    try:
        session.bulk_save_objects(plans)
        session.commit()
    except Exception as e:
        session.rollback()
        raise e

    # Data migration end

    with op.batch_alter_table('recipe', schema=None) as batch_op:
        batch_op.drop_column('planned')
        batch_op.drop_column('planned_days')

    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    with op.batch_alter_table('recipe', schema=None) as batch_op:
        batch_op.add_column(sa.Column('planned_days', sa.VARCHAR(), nullable=True))
        batch_op.add_column(sa.Column('planned', sa.BOOLEAN(), nullable=True))

    op.drop_table('planner')
    # ### end Alembic commands ###
