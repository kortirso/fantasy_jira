import { csrfToken, apiRequest } from 'helpers';

export const createTaskRequest = async (taskName: string) => {
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

  const result = await apiRequest({
    url: `/tasks.json`,
    options: requestOptions,
  });
  return result;
};
