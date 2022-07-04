import React, { useState, useEffect } from 'react';

import { csrfToken, apiRequest, showAlert } from 'helpers';
import { Task } from 'entities';
import { Modal } from 'components/atoms';

import { tasksRequest } from './requests/tasksRequest';

const statuses: KeyValue = {
  'todo': 'To do',
  'in_progress': 'In progress',
  'completed': 'Completed',
  'canceled': 'Canceled'
};

export const Tasks = (): JSX.Element => {
  const [tasks, setTasks] = useState<Task | null>(null);
  const [showModal, setShowModal] = useState(false);
  const [taskName, setTaskName] = useState('');

  useEffect(() => {
    const fetchTasks = async () => {
      const data = await tasksRequest();
      setTasks(data);
    };

    fetchTasks();
  }, []);

  const actionButtons = (task) => {
    if (task.state === 'completed' || task.state === 'canceled') return null;
    if (task.state === 'todo') {
      return (
        <button className="button small">
          Start
        </button>
      )
    } else {
      return (
        <div className="flex flex-row">
          <button className="button small">
            !
          </button>
          <button className="button small">
            -
          </button>
          <button className="button small">
            +
          </button>
        </div>
      )
    }
  };

  const createTask = async () => {
    const payload = {
      task: {
        name: taskName
      },
    };

    const requestOptions = {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-TOKEN': csrfToken(),
      },
      body: JSON.stringify(payload),
    };

    const submitResult = await apiRequest({
      url: `/tasks.json`,
      options: requestOptions,
    });

    if (!submitResult.errors) {
      setTasks(tasks.concat(submitResult.task.data.attributes));
      showAlert('notice', `<p>Task is created</p>`);
    } else {
      submitResult.errors.forEach((error: string) => showAlert('alert', `<p>${error}</p>`));
    }
    setShowModal(false);
  };

  if (!tasks) return <></>;

  return (
    <div className="flex flex-row">
      {Object.entries(statuses).map(([key, value], index) => (
        <div className="flex flex-col flex-1 task-column" key={index}>
          <div className="flex flex-row justify-between task-header">
            <h2>{value}</h2>
            {index === 0 ? (
              <button className="button small" onClick={() => setShowModal(true)}>
                Add new task
              </button>
            ) : null}
          </div>
          <div className="tasks">
            {tasks.filter(task => task.state === key).map(task => (
              <div className="task flex flex-row justify-between" key={`task-${task.id}`}>
                <h3>{task.name}</h3>
                {actionButtons(task)}
              </div>
            ))}
          </div>
        </div>
      ))}
      <Modal show={showModal}>
        <div className="button small modal-close" onClick={() => setShowModal(false)}>
          X
        </div>
        <div id="create-task-header">
          <h2>Add new task</h2>
          <div className="form-field">
            <label className="form-label">Task name</label>
            <input
              className="form-value"
              value={taskName}
              onChange={(e) => setTaskName(e.target.value)}
            />
          </div>
          <button className="button" onClick={createTask}>Create task</button>
        </div>
      </Modal>
    </div>
  );
};
