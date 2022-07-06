import { apiRequest } from 'helpers';

export const tasksApprovementsRequest = async () => {
  const result = await apiRequest({ url: '/tasks/approvements.json' });
  return result;
};
