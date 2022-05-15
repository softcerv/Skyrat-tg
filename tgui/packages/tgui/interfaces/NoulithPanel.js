import { useBackend } from '../backend';
import { LabeledList, Section, Button, Box } from '../components';
import { Window } from '../layouts';

export const NoulithPanel = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    linked_weapon,
    linked_weapon_description,
  } = data;
  return (
    <Window
      title={'Noulith Control Interface'}
      width={500}
      height={350}>
      <Window.Content>
        <Section title={`Weapon Information`}>
          {linked_weapon ? (
            <LabeledList>
              <LabeledList.Item label="Weapon Name">
                {linked_weapon}
              </LabeledList.Item>
              <LabeledList.Item label="Weapon Description">
                {linked_weapon_description}
              </LabeledList.Item>
            </LabeledList>
          ) : (
            <Box
              textAlign="center"
            >
              You are not currently linked to a weapon.
            </Box>
          )}
        </Section>
        <Button
          textAlign="center"
          content={linked_weapon ? "Unattune from Weapon" : "Attune to Weapon"}
          color={linked_weapon ? "red" : "green"}
          fluid
          onClick={() => act("attune")}
        />
      </Window.Content>
    </Window>
  );
};
