import { csrfToken, apiRequest } from 'helpers';

export const updateTaskRequest = async (attributes: any) => {
  const payload = {
    task: attributes,
  };

  const requestOptions = {
    method: 'PATCH',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-TOKEN': csrfToken(),
    },
    body: JSON.stringify(payload),
  };

  const result = await apiRequest({
    url: `/tasks/${attributes.id}.json`,
    options: requestOptions,
  });
  return result;
};
