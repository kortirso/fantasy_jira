# frozen_string_literal: true

describe TasksController, type: :controller do
  describe 'GET#index' do
    context 'for unlogged users' do
      it 'redirects to login path' do
        get :index

        expect(response).to redirect_to users_login_path
      end
    end

    context 'for logged users' do
      sign_in_user

      context 'for html request' do
        it 'renders index template' do
          get :index

          expect(response).to render_template :index
        end
      end

      context 'for json request' do
        before do
          create :task, state: Task::TODO
          create :task, state: Task::IN_PROGRESS
        end

        context 'without additional params' do
          before do
            get :index, params: { format: :json }
          end

          it 'returns status 200' do
            expect(response.status).to eq 200
          end

          it 'returns all tasks' do
            result = JSON.parse(response.body)['tasks']['data']

            expect(result.size).to eq 2
          end

          %w[id name state].each do |attr|
            it "contains task #{attr}" do
              expect(response.body).to have_json_path("tasks/data/0/attributes/#{attr}")
            end
          end
        end

        context 'with additional params' do
          before do
            get :index, params: { format: :json, state: Task::TODO }
          end

          it 'returns status 200' do
            expect(response.status).to eq 200
          end

          it 'returns only specific tasks', :aggregate_failures do
            result = JSON.parse(response.body)['tasks']['data']

            expect(result.size).to eq 1
            expect(result[0]['attributes']['state']).to eq Task::TODO
          end
        end
      end
    end
  end

  describe 'POST#create' do
    context 'for unlogged users' do
      it 'redirects to login path' do
        post :create

        expect(response).to redirect_to users_login_path
      end
    end

    context 'for logged users' do
      sign_in_user

      context 'for invalid request' do
        let(:request) { post :create, params: { task: { name: '' } } }

        it 'does not create new task' do
          expect { request }.not_to change(Task, :count)
        end

        context 'in response' do
          before do
            request
          end

          it 'returns status 422' do
            expect(response.status).to eq 422
          end

          it 'contains errors list' do
            expect(response.body).to have_json_path('errors/0')
          end
        end
      end

      context 'for valid request' do
        let(:request) { post :create, params: { task: { name: 'Task' } } }

        it 'creates new task' do
          expect { request }.to change(Task, :count).by(1)
        end

        context 'in response' do
          before do
            request
          end

          it 'returns status 200' do
            expect(response.status).to eq 200
          end

          %w[id name state].each do |attr|
            it "contains task #{attr}" do
              expect(response.body).to have_json_path("task/data/attributes/#{attr}")
            end
          end
        end
      end
    end
  end

  describe 'PATCH#update' do
    let!(:task) { create :task, state: Task::IN_PROGRESS }

    context 'for unlogged users' do
      it 'redirects to login path' do
        patch :update, params: { id: task.id }

        expect(response).to redirect_to users_login_path
      end
    end

    context 'for logged users' do
      sign_in_user

      context 'for unknown task' do
        it 'renders 404 page' do
          patch :update, params: { id: 'unknown', task: { state: Task::COMPLETED } }

          expect(response).to render_template 'shared/404'
        end
      end

      context 'for invalid request' do
        let(:request) { patch :update, params: { id: task.id, task: { state: Task::COMPLETED } } }

        it 'does not update task' do
          request

          expect(task.reload.state).to eq Task::IN_PROGRESS
        end

        context 'in response' do
          before do
            request
          end

          it 'returns status 200' do
            expect(response.status).to eq 200
          end

          %w[id name state].each do |attr|
            it "contains task #{attr}" do
              expect(response.body).to have_json_path("task/data/attributes/#{attr}")
            end
          end

          it 'contains errors list' do
            expect(response.body).to have_json_path('errors/0')
          end
        end
      end

      context 'for valid request' do
        let(:request) { patch :update, params: { id: task.id, task: { state: Task::CANCELED } } }

        it 'updates task' do
          request

          expect(task.reload.state).to eq Task::CANCELED
        end

        context 'in response' do
          before do
            request
          end

          it 'returns status 200' do
            expect(response.status).to eq 200
          end

          %w[id name state].each do |attr|
            it "contains task #{attr}" do
              expect(response.body).to have_json_path("task/data/attributes/#{attr}")
            end
          end

          it 'does not contain errors list' do
            expect(response.body).not_to have_json_path('errors/0')
          end
        end
      end
    end
  end
end
