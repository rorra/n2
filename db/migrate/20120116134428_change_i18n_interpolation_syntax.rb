class ChangeI18nInterpolationSyntax < ActiveRecord::Migration
  def up
    # The i18n gem changed {{ ... }} to %{ .. }
    execute "update translations set value = replace(value, '{{', '%{');"
    execute "update translations set value = replace(value, '}}', '}');"
  end

  def down
  end
end
