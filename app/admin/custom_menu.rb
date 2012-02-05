
class Admin::CustomMenu < Arbre::HTML::Div
  def build *args
    ul :class => 'header-item', :id => 'tabs' do
      home_link
      content_menu
      features_menu
      communities_menu
    end
  end

  private

  def home_link
      li { link_to 'Home', '/activeadmin' }
  end

  def content_menu
    li :class => 'has_nested' do
      text_node link_to("Front Page", '#')
      ul do
        li { link_to 'Front Page - Build Layout', '#' }
        li { link_to 'Front Page - Custom Widgets', '#' }
        li { link_to 'Flagged Items', '#' }
        li { link_to 'Stories', '/activeadmin/stories' }
        li { link_to 'Comments', '/activeadmin/comments' }
        li { link_to 'Images', '#' }
        li { link_to 'News Feeds', '#' }
        li { link_to 'Feed Items', '#' }
        li { link_to 'Related Items', '#' }
        li { link_to 'Twitter Lists - Tweet Streams', '#' }
        li { link_to 'Twitter Lists - Tweets', '#' }
        li { link_to 'Twitter Lists - Tweet Accounts', '#' }
      end
    end
  end

  def features_menu
    li :class => 'has_nested' do
      text_node(link_to "Features", '#')
      ul do
        li { link_to 'Calendar - Manage Events', '#' }
        li { link_to 'Calendar - Import from Zvents', '#' }
      end
    end
  end

  def communities_menu
  end
end

ActiveAdmin.application.view_factory.register :global_navigation => Admin::CustomMenu
