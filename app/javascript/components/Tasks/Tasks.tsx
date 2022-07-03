import React, { useState, useEffect } from 'react';

import { Task } from 'entities';

import { tasksRequest } from './requests/tasksRequest';

const statuses: KeyValue = {
  'todo': 'To do',
  'in_progress': 'In progress',
  'completed': 'Completed',
  'canceled': 'Canceled'
};

export const Tasks = (): JSX.Element => {
  const [tasks, setTasks] = useState<Task | null>(null);

  useEffect(() => {
    const fetchTasks = async () => {
      const data = await tasksRequest();
      setTasks(data);
    };

    fetchTasks();
  }, []);

  if (!tasks) return <></>;

  return (
    <div className="flex flex-row">
      {Object.entries(statuses).map(([key, value], index) => (
        <div className="flex flex-col flex-1" key={index}>
          <div className="flex flex-row justify-between">
            <h2>{value}</h2>
            {index === 0 ? (
              <button className="button small">
                Add new task
              </button>
            ) : null}
          </div>
        </div>
      ))}
    </div>
  );
};
