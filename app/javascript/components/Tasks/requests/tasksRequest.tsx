import { Attribute } from 'entities';
import { apiRequest } from 'helpers';

export const tasksRequest = async () => {
  const result = await apiRequest({ url: '/tasks.json' });
  return result.tasks.data.map((element: Attribute) => element.attributes);
};
