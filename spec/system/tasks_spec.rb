require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:task) { create(:task) }

  describe 'ログイン前' do
    describe 'ページの遷移' do
      context 'タスクの新規作成ページにアクセス' do
        it '新規作成ページへのアクセスが失敗する' do
          visit new_task_path
          expect(current_path).to eq login_path
          expect(page).to have_content "Login required"
        end
      end
      context 'タスクの編集ページにアクセス' do
        it '編集ページへのアクセスが失敗する' do
          visit edit_task_path(task)
          expect(current_path).to eq login_path
          expect(page).to have_content "Login required"
        end
      end
    end
  end

  describe 'ログイン後' do
    before { login(user) }
    describe 'タスクの新規作成' do
      context 'フォームの入力が正常' do
        it 'タスクの新規作成が成功する' do
          visit new_task_path
          fill_in "Title", with: "test"
          fill_in "Content", with: "test"
          select "doing", from: "Status"
          fill_in "Deadline", with: DateTime.new(2030, 1, 1, 0, 0)
          click_button "Create Task"
          expect(page).to have_content "Task was successfully created."
          expect(page).to have_content "Title: test"
          expect(page).to have_content "Content: test"
          expect(page).to have_content "Status: doing"
          expect(page).to have_content "Deadline: 2030/1/1 0:0"
          expect(current_path).to eq "/tasks/1"
        end
      end
      context 'タイトルが未入力' do
        it 'タスクの新規作成が失敗する' do
          visit new_task_path
          fill_in "Title", with: ""
          fill_in "Content", with: "test"
          select "doing", from: "Status"
          fill_in "Deadline", with: DateTime.new(2030, 1, 1, 0, 0)
          click_button "Create Task"
          expect(page).to have_content "1 error prohibited this task from being saved:"
          expect(page).to have_content "Title can't be blank"
          expect(current_path).to eq tasks_path
        end
      end
      context '登録済のタイトルを入力' do
        it 'タスクの新規作成が失敗する' do
          visit new_task_path
          other_task = create(:task)
          fill_in "Title", with: other_task.title
          fill_in "Content", with: "test"
          select "doing", from: "Status"
          fill_in "Deadline", with: DateTime.new(2030, 1, 1, 0, 0)
          click_button "Create Task"
          expect(page).to have_content "1 error prohibited this task from being saved:"
          expect(page).to have_content "Title has already been taken"
          expect(current_path).to eq tasks_path
        end
      end
    end

    describe 'タスクの編集' do
      let!(:task) { create(:task, user: user) }
      let(:other_task) { create(:task, user: user) }
      context 'フォームの入力が正常' do
        it 'タスクの編集が成功する' do
          visit edit_task_path(task)
          fill_in "Title", with: "test2"
          fill_in "Content", with: "test2"
          select "todo", from: "Status"
          click_button "Update Task"
          expect(page).to have_content "Task was successfully updated."
          expect(page).to have_content "Title: test2"
          expect(page).to have_content "Content: test2"
          expect(page).to have_content "Status: todo"
          expect(current_path).to eq task_path(task)
        end
      end
      context 'タイトルが未入力' do
        it 'タスクの編集が失敗する' do
          visit edit_task_path(task)
          fill_in "Title", with: ""
          fill_in "Content", with: "test"
          select "doing", from: "Status"
          click_button "Update Task"
          expect(page).to have_content "1 error prohibited this task from being saved:"
          expect(page).to have_content "Title can't be blank"
          expect(current_path).to eq task_path(task)
        end
      end
      context '登録済のタイトルを入力' do
        it 'タスクの編集が失敗する' do
          visit edit_task_path(task)
          fill_in "Title", with: other_task.title
          fill_in "Content", with: "test"
          select "doing", from: "Status"
          click_button "Update Task"
          expect(page).to have_content "1 error prohibited this task from being saved:"
          expect(page).to have_content "Title has already been taken"
          expect(current_path).to eq task_path(task)
        end
      end
      context '他ユーザーのタスク編集ページにアクセス' do
        it 'タスク編集ページへのアクセスが失敗する' do
          other_user_task = create(:task, user: other_user)
          visit edit_task_path(other_user_task)
          expect(current_path).to eq root_path
          expect(page).to have_content "Forbidden access."
        end
      end
    end

    describe 'タスクの削除' do
      let!(:task) { create(:task, user: user) }
      it 'タスクの削除が成功する' do
        visit tasks_path
        click_link "Destroy"
        expect(page.accept_confirm).to eq "Are you sure?"
        expect(current_path).to eq tasks_path
        expect(page).to have_content "Task was successfully destroyed."
        expect(page).not_to have_content task.title
      end
    end
  end
end
