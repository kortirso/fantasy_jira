import React, { useState, useEffect } from 'react';

import { showAlert } from 'helpers';
import { Task, TaskInput, KeyValue } from 'entities';
import { Modal } from 'components/atoms';

import { tasksRequest } from './requests/tasksRequest';
import { tasksApprovementsRequest } from './requests/tasksApprovementsRequest';
import { approveTaskRequest } from './requests/approveTaskRequest';
import { createTaskRequest } from './requests/createTaskRequest';
import { updateTaskRequest } from './requests/updateTaskRequest';

const statuses: KeyValue = {
  todo: 'To do',
  in_progress: 'In progress',
  completed: 'Completed',
  canceled: 'Canceled',
};

export const Tasks = (): JSX.Element => {
  const [tasks, setTasks] = useState<Task[]>([]);
  const [tasksApprovements, setTasksApprovements] = useState<any>({});
  const [showModal, setShowModal] = useState(false);
  const [taskName, setTaskName] = useState('');

  useEffect(() => {
    const fetchTasks = async () => {
      const data = await tasksRequest();
      setTasks(data);
    };

    const fetchTasksApprovements = async () => {
      const data = await tasksApprovementsRequest();
      setTasksApprovements(data);
    };

    fetchTasks();
    fetchTasksApprovements();
  }, []);

  const actionButtons = (task: Task) => {
    if (task.state === 'completed' || task.state === 'canceled') return null;
    if (task.state === 'todo') {
      return (
        <button
          className="button small"
          onClick={() => updateTask({ id: task.id, state: 'in_progress' })}
        >
          Start
        </button>
      );
    } else {
      return (
        <div className="flex flex-row">
          <button
            className="button small"
            onClick={() => updateTask({ id: task.id, state: 'completed' })}
          >
            +
          </button>
          <button
            className="button small"
            onClick={() => updateTask({ id: task.id, state: 'canceled' })}
          >
            -
          </button>
          <button className="button small" onClick={() => approveTask(task.id)}>
            Approve ({tasksApprovements[task.id] || 0})
          </button>
        </div>
      );
    }
  };

  const createTask = async () => {
    const result = await createTaskRequest(taskName);
    if (!result.errors) {
      setTasks(tasks.concat(result.task.data.attributes));
      showAlert('notice', `<p>Task is created</p>`);
    } else {
      result.errors.forEach((error: string) => showAlert('alert', `<p>${error}</p>`));
    }
    setShowModal(false);
  };

  const updateTask = async (attributes: TaskInput) => {
    const result = await updateTaskRequest(attributes);
    result.errors.forEach((error: string) => showAlert('alert', `<p>${error}</p>`));
    const updatedTask = result.task.data.attributes;
    setTasks(
      tasks.map((task) => {
        if (task.id !== attributes.id) return task;
        return updatedTask;
      }),
    );
  };

  const approveTask = async (taskId: number) => {
    const result = await approveTaskRequest(taskId);
    setTasksApprovements({ ...tasksApprovements, ...result });
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
            {tasks
              .filter((task) => task.state === key)
              .map((task) => (
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
          <button className="button" onClick={createTask}>
            Create task
          </button>
        </div>
      </Modal>
    </div>
  );
};
