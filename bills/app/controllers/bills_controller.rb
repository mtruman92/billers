class BillsController < ApplicationController


    # If: logged_in? @user = current_user, load users bills. Else: redirect /login #
    get '/bills' do
      if logged_in? && current_user
        @bills = current_user.bills
        erb :'/bills/show.html'
      else
        redirect '/login'
      end
    end

    # Check if user is logged in to add a new bill #
    get '/bills/new' do
      if logged_in?
        @user = current_user
        erb :'/bills/create_bill'
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
        @bill.paid = params[:paid]
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
        erb :"/bills/edit"
      else
        redirect '/login'
      end
    end

    # If logged_in? and bill's user is valid: Find bill by ID, load edit form. Otherwise load bill show page if not correct user. Else: /login #
    get '/bills/:id/edit' do
    if logged_in?
      @bill = Bill.find(params[:id])
      if @bill.user_id == current_user.id
        erb :'bills/edit_bill'
      else
        redirect '/login'
      end
    else
      redirect_if_not_logged_in
    end
  end


    # If logged_in? && bill has a name, update the name + attributes, redirect to that bill page. Else: Reload edit form #
    patch "/bills/:id" do
      @bill = set_bill
      if logged_in? && @bill.user == current_user
        @bill.update(params[:bill]) # Mass update the bill attributes <%= @bill.bill_name%>
        redirect '/bills'

      else
        if logged_in?
         redirect "/bills/#{@bill.id}"
        else
          redirect '/login'
        end
      end
     end


    # Delete bill if logged_in? and current_user is the creator. Otherwise, load bill index page. Else: reload /login #
    delete "/bills/:id/delete" do
      if logged_in?
        @bill = set_bill
        if @bill.user == current_user
          @bill.destroy
          redirect '/bills'
        else
          redirect '/bills'
        end
      else
        redirect '/login'
      end
    end



    def set_bill
      Bill.find_by_id(params[:id])
    end

end
