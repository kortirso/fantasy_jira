import { Attribute } from 'entities';
import { apiRequest } from 'helpers/apiRequest';

export const tasksRequest = async (id: number) => {
  const result = await apiRequest({ url: '/tasks.json' });
  return result.tasks.map((element: Attribute) => element.attributes);
};
