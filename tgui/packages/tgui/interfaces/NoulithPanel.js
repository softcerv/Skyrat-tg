import { useBackend } from '../backend';
import { LabeledList, Section, Button, Box, Collapsible, BlockQuote, Input } from '../components';
import { Window } from '../layouts';

const NoulithAbilities = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    pull_on_cooldown,
    weapon_stowed,
  } = data;
  return (
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

  ); };

const NoulithWeaponLore = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    weapon_lore,
  } = data;
  return (
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

  );
};


const StowWeapon = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    weapon_stowed,
  } = data;
  return (
    <Button
      textAlign="center"
      content="Stow Weapon"
      tooltip="Stows your current weapon behind your back."
      fluid
      onClick={() => act("stow_weapon")}
    />
  );
};

const AttuneToWeapon = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    weapon_stowed,
    linked_weapon,
  } = data;
  return (
    <Button
      textAlign="center"
      content={linked_weapon ? "Unattune from the linked weapon" : "Attune to a weapon"}
      color={linked_weapon ? "red" : "green"}
      disabled={weapon_stowed ? true : false}
      fluid
      onClick={() => act("attune")}
    />
  );
};

const CustomizationOptions = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    weapon_stowed,
    linked_weapon,
  } = data;
  return (
    <Section title={"Customization Options"}>
      <Box>
        {"Custom Description "}
        <Input
          content="Custom Description"
          width="70%"
          onEnter={(e, value) => act("change_examine", {
            new_text: value,
          })} />
      </Box>
    </Section>
  );
};

export const NoulithPanel = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    linked_weapon,
    linked_weapon_description,
    weapon_stowed,
  } = data;

  return (
    <Window
      title={'Noulith Control Interface'}
      width={500}
      height={350}>
      <Window.Content>
        {(linked_weapon && !weapon_stowed) ? (
          <NoulithAbilities />
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
          <>
            <StowWeapon />
            <NoulithWeaponLore />
          </>
        ) : (<> </>)}
        <AttuneToWeapon />
        {linked_weapon ? (
          <CustomizationOptions />
        ) : (<> </>)}
      </Window.Content>
    </Window>
  );
};
