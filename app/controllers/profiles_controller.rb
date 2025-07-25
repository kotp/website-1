class ProfilesController < ApplicationController
  skip_before_action :authenticate_user!, except: %i[intro new create]
  before_action :cache_public_action!, except: %i[intro new create]

  before_action :use_user, except: %i[index intro new create]
  before_action :use_profile, except: %i[index intro new create tooltip]

  def index
    redirect_to contributing_contributors_path
  end

  def show
    return unless stale?(etag: @profile)

    @solutions = Solution::SearchUserSolutions.(@user, status: :published, per: 3)

    # TODO: Order by most prominent first (what is the most prominent testimonial?)
    @testimonials = @user.mentor_testimonials.published.first(3)
  end

  def solutions
    redirect_to profile_path(@user) unless @profile.solutions_tab?
    return unless stale?(etag: @profile)

    @solutions = Solution::SearchUserSolutions.(
      @user,
      status: :published
    )
  end

  def contributions
    redirect_to profile_path(@user) unless @profile.contributions_tab?
    nil unless stale?(etag: @profile)
  end

  # TODO: (Optional) Add tests for published scope
  def testimonials
    redirect_to profile_path(@user) unless @profile.testimonials_tab?
    nil unless stale?(etag: @profile)
  end

  def badges
    return unless stale?(etag: @profile)

    @badges = @user.revealed_badges.ordered_by_rarity
    @rarities = @badges.group(:rarity).count
  end

  def tooltip
    expires_in 1.minute

    render_template_as_json
  end

  def intro
    return redirect_to profile_path(current_user) if current_user&.profile

    @profile_min_reputation = User::Profile::MIN_REPUTATION
    @may_create_profile = current_user&.may_create_profile?
  end

  def new
    return redirect_to profile_path(current_user) if current_user.profile
    return redirect_to action: :intro unless current_user.may_create_profile?

    @profile = User::Profile.new
  end

  private
  def use_user
    @user = User.find_by(handle: params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def use_profile
    @profile = @user&.profile
    return if @profile

    return redirect_to action: :intro if current_user&.handle == params[:id]

    render_404
  end
end
