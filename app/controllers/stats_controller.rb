class StatsController < ApplicationController
  def index
    self.overall_stats
    self.past_7_days_stats
    self.today_stats
    self.recent_searches
    
    render :layout => "application", :template => "stats"
  end
  
  def overall_stats
    @overall_stats = []
    
    @overall_stats << ["Searchs"   ,    Searches.count]
    @overall_stats << ["Playlists" ,    Playlist.count]
    @overall_stats << ["Users"     ,        User.count]
  end
  
  def past_7_days_stats
    @past_7_days_stats = []
    
    @past_7_days_stats << ["Searches"  ,  Searches.where("created_at >= ?", Date.today-7).count]
    @past_7_days_stats << ["Playlists" ,  Playlist.where("created_at >= ?", Date.today-7).count]
    @past_7_days_stats << ["Users"     ,      User.where("created_at >= ?", Date.today-7).count]
  end
  
  def today_stats
    @today_stats = []
    
    @today_stats << ["Searches"  ,  Searches.where("created_at >= ?", Date.today).count]
    @today_stats << ["Playlists" ,  Playlist.where("created_at >= ?", Date.today).count]
    @today_stats << ["Users"     ,      User.where("created_at >= ?", Date.today).count]
  end
  
  def recent_searches
    @recent_searches    = []
    tmp_recent_searches = Searches.find(:all, :limit => 100, :order => "created_at DESC")
    
    tmp_recent_searches.each do | search |
      if search.search_type == 'just' || search.search_type == 'genre' || search.search_type == 'similar'
        if @recent_searches.select {|s| s[:what] == search.what.gsub("+"," ") && s[:who] == search.who }.length == 0
          @recent_searches << {
            :what => search.what.gsub("+"," "),
            :date => search.created_at,
            :type => search.search_type,
            :url  => "/#{search.search_type}/#{search.what.gsub(" ","+")}",
            :who  => search.who
          } 
        end
      end
    end
    
    return @recent_searches
  end
end