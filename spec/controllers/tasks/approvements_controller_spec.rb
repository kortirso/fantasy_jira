# frozen_string_literal: true

describe Tasks::ApprovementsController, type: :controller do
  describe 'GET#index' do
    let!(:task) { create :task, state: Task::IN_PROGRESS }

    context 'for unlogged users' do
      it 'redirects to login path' do
        get :index

        expect(response).to redirect_to users_login_path
      end
    end

    context 'for logged users' do
      sign_in_user

      before do
        create :tasks_approvement, user: @current_user, task: task

        get :index
      end

      it 'returns status 200' do
        expect(response.status).to eq 200
      end

      it 'returns hash with task ids and count of approvements' do
        result = JSON.parse(response.body)

        expect(result).to eq({ task.id.to_s => 1 })
      end
    end
  end

  describe 'POST#create' do
    context 'for unlogged users' do
      it 'redirects to login path' do
        post :create, params: { task_id: 'unknown' }

        expect(response).to redirect_to users_login_path
      end
    end

    context 'for logged users' do
      sign_in_user

      context 'for unknown task' do
        it 'renders 404 page' do
          post :create, params: { task_id: 'unknown' }

          expect(response).to render_template 'shared/404'
        end
      end

      context 'for invalid request' do
        let!(:task) { create :task, state: Task::TODO }
        let(:request) { post :create, params: { task_id: task.id } }

        it 'renders 404 page' do
          post :create, params: { task_id: 'unknown' }

          expect(response).to render_template 'shared/404'
        end
      end

      context 'for valid request' do
        let!(:task) { create :task, state: Task::IN_PROGRESS }
        let(:request) { post :create, params: { task_id: task.id } }

        context 'without existing approvements' do
          it 'creates new tasks approvement' do
            expect { request }.to change(Tasks::Approvement, :count).by(1)
          end

          context 'in response' do
            before do
              request
            end

            it 'returns status 200' do
              expect(response.status).to eq 200
            end

            it 'returns hash with task ids and count of approvements' do
              result = JSON.parse(response.body)

              expect(result).to eq({ task.id.to_s => 1 })
            end
          end
        end

        context 'with existing approvements' do
          before do
            create :tasks_approvement, user: @current_user, task: task
          end

          it 'does not create new tasks approvement' do
            expect { request }.not_to change(Tasks::Approvement, :count)
          end

          context 'in response' do
            before do
              request
            end

            it 'returns status 200' do
              expect(response.status).to eq 200
            end

            it 'returns hash with task ids and count of approvements' do
              result = JSON.parse(response.body)

              expect(result).to eq({ task.id.to_s => 1 })
            end
          end
        end
      end
    end
  end
end
