class BillsController < ApplicationController



    # If: logged_in? @user = current_user, load users bills. Else: redirect /login #
    get '/bills' do
      if logged_in? && current_user
        @user = current_user
        @bill = Bill.all
        erb :'/bills/index.html'
      else
        redirect '/login'
      end
    end

    # Check if user is logged in to add a new bill #
    get '/bills/new' do
      if logged_in?
        @user = current_user
        erb :'/bills/new.html'
      else
        redirect '/login'
      end
    end


    # User must be logged_in && params must be filled out to create an entry #
    post '/bills' do
      if logged_in?
        @bill = Bill.new(bill_name: params[:bill_name])
        @bill.bill_amount = params[:bill_amount]
        @bill.due_date = params[:due_date]
        @bill.auto_pay = params[:auto_pay]
        @bill.category = params[:category]
        @bill.repeat = params[:repeat]
        @bill.user_id = current_user.id
        @bill.save
        redirect "/bills/#{@bill.id}"
      else
        redirect 'bills/new.html'
      end
    end



    # If logged_in, show the bill by finding the ID. Else: force /login page #
    get "/bills/:id" do
      if logged_in?
        set_bill
        erb :"/bills/show.html"
      else
        redirect '/login'
      end
    end

    # If logged_in? and bill's user is valid: Find bill by ID, load edit form. Otherwise load bill show page if not correct user. Else: /login #
    get "/bills/:id/edit" do
      set_bill
      if logged_in? && @bill.user_id == current_user.id
        erb :"/bills/edit.html"
      elsif logged_in? && @bill.user_id != current_user.id
        redirect "/bills/#{@bill.id}"
      else
        redirect '/login'
      end
    end

    # If logged_in? && bill has a name, update the name + attributes, redirect to that bill page. Else: Reload edit form #
    patch "/bills/:id" do
      set_bill
      if logged_in? && @bill.user_id == current_user
        @bill.update(params[:bill_name]) # Mass update the bill attributes
        @bill.save
        redirect "/bills/#{@bill.id}"
      else
        if logged_in?
          #flash[:message] = @user.errors.messages
          redirect "/bills/#{@bill.id}"
        else
          redirect '/login'
        end
      end
    end

    # Delete bill if logged_in? and current_user is the creator. Otherwise, load bill index page. Else: reload /login #
    delete "/bills/:id/delete" do
      if logged_in?
        set_bill
        if @bill.user_id == current_user.id
          @bill.delete
          redirect '/bills'
        else
          redirect '/bills'
        end
      else
        redirect '/login'
      end
    end



    def set_bill
      @bill = Bill.find_by_id(params[:id])

    end

end
