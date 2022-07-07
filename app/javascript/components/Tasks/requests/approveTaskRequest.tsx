import { csrfToken, apiRequest } from 'helpers';

export const approveTaskRequest = async (taskId: number) => {
  const requestOptions = {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-TOKEN': csrfToken(),
    },
  };

  const result = await apiRequest({
    url: `/tasks/${taskId}/approvements.json`,
    options: requestOptions,
  });
  return result;
};
