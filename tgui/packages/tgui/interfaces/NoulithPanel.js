import { useBackend } from '../backend';
import { LabeledList, Section, Button, Box, Collapsible, BlockQuote } from '../components';
import { Window } from '../layouts';

export const NoulithPanel = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    linked_weapon,
    linked_weapon_description,
    pull_on_cooldown,
    weapon_lore,
  } = data;
  return (
    <Window
      title={'Noulith Control Interface'}
      width={500}
      height={350}>
      <Window.Content>
        {linked_weapon ? (
          <Section title={`Weapon Abilities`}>
            <Button
              textAlign="center"
              content="Summon Weapon"
              tooltip="Summons your currently linked weapon to your hand. Requires you to be close, or have a special weapon."
              fluid
              onClick={() => act("summon")}
            />
            <Button
              textAlign="center"
              content="Pull Weapon"
              tooltip="Pulls your linked weapon towards you, possibly hitting anything in the way. Have your hand empty before using this, to avoid injury"
              fluid
              disabled={pull_on_cooldown ? true : false}
              onClick={() => act("pull_weapon")}
            />
          </Section>
        ) : (<> </>)}
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
        {linked_weapon ? (
          <Collapsible
            fluid
            textAlign="center"
            content="Show Weapon Lore"
          >
            <Section>
              <BlockQuote>
                {weapon_lore}
              </BlockQuote>
            </Section>
          </Collapsible>
        ) : (<> </>)}
        <Button
          textAlign="center"
          content={linked_weapon ? "Unattune from the linked weapon" : "Attune to a weapon"}
          color={linked_weapon ? "red" : "green"}
          fluid
          onClick={() => act("attune")}
        />
      </Window.Content>
    </Window>
  );
};
