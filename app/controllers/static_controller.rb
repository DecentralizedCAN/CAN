class StaticController < ApplicationController
	before_action :require_login, except: [:documentation]

	def home
	end

	def main_feed

		if true
			@posts = Post.left_joins(:upvotes)
			  .group(:id)
				.having('count(upvotes.id) > 0')
			  .paginate(:page => params[:page], :per_page => 12)
			  .order("COUNT(upvotes.id) / (( extract(epoch from now()) - extract(epoch from posts.created_at) / 1.002) ) DESC")
		else
			@posts = Post.paginate(:page => params[:page], :per_page => 12)
			  .order('created_at DESC')
		end

    @current_time = Time.now.to_i
    @notifications = current_user.notification.order("created_at DESC").first(6) if logged_in?

    find_quote

	end

	def documentation
		
	end

	def notifications
    @notifications = current_user.notification.order("created_at DESC")
    .paginate(:page => params[:page], :per_page => 20)
	end

	def destroy
		if current_user.admin?
			@post = Post.find(params[:post_id])
			@post.destroy
		end
	end

	def commitments
		@user = current_user

		# puts @user.to_json
		# redirect_to login_path if @user == nil

		@commitments = @user.rolls
		@sponsored_problems = @user.problems
		# @problems = Problem.last(5)
		# @activities = Activity.last(5)
		@proposals = @user.solution
    @current_time = Time.now.to_i
	end

	def manage
		if current_user.admin?
	    @problems = Problem.paginate(:page => params[:page], :per_page => 100).order('created_at DESC')
	    @activities = Activity.paginate(:page => params[:page], :per_page => 100).order('created_at DESC')
	    @discussions = Discussion.paginate(:page => params[:page], :per_page => 100).order('created_at DESC')
		else
			redirect_to root_url			
		end
	end

	def wakemydyno
		render "wakemydyno.txt"
	end

	def find_quote
		@quotes = [
		    ['I\'ve said it since day one: I can\'t do it alone.', 'Bernie Sanders'],
		    ['The only way that real change takes place is when millions of people stand up, fight back, and say, "Enough is enough. We\'re gonna have a government that works for all of us, not just the few."', 'Bernie Sanders'],
		    ['Some individuals and groups...may naïvely think that if they simply espouse their goal strongly, firmly, and long enough, it will somehow come to pass...The espousal of humane goals and loyalty to ideals are admirable, but are grossly inadequate.', 'Gene Sharp'],
		    ['Real change never takes place from the top on down. It always takes place from the bottom on up. It takes place when ordinary people, by the millions, are prepared to stand up and fight for justice.', 'Bernie Sanders'],
		    [' It is not just about electing Bernie Sanders for president, it is about creating a grassroots political movement in this country.', 'Bernie Sanders'],
		    ['Let us wage a moral and political war against the billionaires and corporate leaders, on Wall Street and elsewhere, whose policies and greed are destroying the middle class of America.', 'Bernie Sanders'],
		    ['Rise like Lions after slumber, in unvanquishable number. Shake your chains to earth like dew, which in sleep had fallen on you. 
		      Ye are many — they are few.', 'Percy Bysshe Shelley'],
		    ['We need a mass movement of people over many years to bring about the change that we need. That is what this political revolution is about—returning power to the people, where it belongs.', 'Bernie Sanders'],
		    ['When millions of people stand up and fight...they win.', 'Bernie Sanders'],
		    ['All your political agitation will end as other agitations have done, in smoke, unless you band yourselves together...and organize.', 'Charles Stewart Parnell'],
		    ['the only way we will pass policies like Medicare for All and a Green New Deal is by organizing the largest grassroots movement American politics has ever seen.', 'Bernie Sanders'],
		    # [],
		    # [],
		    # [],
		    ['I\'ve said it since day one: I can\'t do it alone.', 'Bernie Sanders'],
		    ['The only way that real change takes place is when millions of people stand up, fight back, and say, "Enough is enough. We\'re gonna have a government that works for all of us, not just the few."', 'Bernie Sanders'],
		    ['Some individuals and groups...may naïvely think that if they simply espouse their goal strongly, firmly, and long enough, it will somehow come to pass...The espousal of humane goals and loyalty to ideals are admirable, but are grossly inadequate.', 'Gene Sharp'],
		    ['Real change never takes place from the top on down. It always takes place from the bottom on up. It takes place when ordinary people, by the millions, are prepared to stand up and fight for justice.', 'Bernie Sanders'],
		    [' It is not just about electing Bernie Sanders for president, it is about creating a grassroots political movement in this country.', 'Bernie Sanders'],
		    ['Let us wage a moral and political war against the billionaires and corporate leaders, on Wall Street and elsewhere, whose policies and greed are destroying the middle class of America.', 'Bernie Sanders'],
		    ['Rise like Lions after slumber, in unvanquishable number. Shake your chains to earth like dew, which in sleep had fallen on you. 
		      Ye are many — they are few.', 'Percy Bysshe Shelley'],
		    ['We need a mass movement of people over many years to bring about the change that we need. That is what this political revolution is about—returning power to the people, where it belongs.', 'Bernie Sanders'],
		    ['When millions of people stand up and fight...they win.', 'Bernie Sanders'],
		    ['All your political agitation will end as other agitations have done, in smoke, unless you band yourselves together...and organize.', 'Charles Stewart Parnell'],
		    ['I\'ve said it since day one: I can\'t do it alone.', 'Bernie Sanders'],
		    ['The only way that real change takes place is when millions of people stand up, fight back, and say, "Enough is enough. We\'re gonna have a government that works for all of us, not just the few."', 'Bernie Sanders'],
		    ['Some individuals and groups...may naïvely think that if they simply espouse their goal strongly, firmly, and long enough, it will somehow come to pass...The espousal of humane goals and loyalty to ideals are admirable, but are grossly inadequate.', 'Gene Sharp'],
		    ['Real change never takes place from the top on down. It always takes place from the bottom on up. It takes place when ordinary people, by the millions, are prepared to stand up and fight for justice.', 'Bernie Sanders'],
		    [' It is not just about electing Bernie Sanders for president, it is about creating a grassroots political movement in this country.', 'Bernie Sanders'],
		    ['Let us wage a moral and political war against the billionaires and corporate leaders, on Wall Street and elsewhere, whose policies and greed are destroying the middle class of America.', 'Bernie Sanders'],
		    ['Rise like Lions after slumber, in unvanquishable number. Shake your chains to earth like dew, which in sleep had fallen on you. 
		      Ye are many — they are few.', 'Percy Bysshe Shelley'],
		    ['We need a mass movement of people over many years to bring about the change that we need. That is what this political revolution is about—returning power to the people, where it belongs.', 'Bernie Sanders'],
		    ['When millions of people stand up and fight...they win.', 'Bernie Sanders'],
		    ['All your political agitation will end as other agitations have done, in smoke, unless you band yourselves together...and organize.', 'Charles Stewart Parnell'],

		  ]

		  @quote = @quotes[Time.now.hour]
	end
end