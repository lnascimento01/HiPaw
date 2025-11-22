import 'exercise.dart';

class BlueprintLevelData {
  const BlueprintLevelData({
    required this.description,
    required this.materials,
    required this.steps,
    this.notes = '',
  });

  final String description;
  final List<String> materials;
  final List<String> steps;
  final String notes;
}

class DocxExerciseBlueprint {
  const DocxExerciseBlueprint({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.pillars,
    required this.initial,
    required this.intermediate,
    required this.advanced,
    this.videoUrl = '',
  });

  final String id;
  final String title;
  final String subtitle;
  final List<PsychomotorPillar> pillars;
  final BlueprintLevelData initial;
  final BlueprintLevelData intermediate;
  final BlueprintLevelData advanced;
  final String videoUrl;
}

const docxExerciseBlueprints = <DocxExerciseBlueprint>[
  DocxExerciseBlueprint(
    id: 'beads-string',
    title: 'Enfiar Pérolas no Cordão',
    subtitle: 'Coordenação motora fina com ajuda do cão',
    pillars: [PsychomotorPillar.motora, PsychomotorPillar.cognitiva],
    videoUrl: '',
    initial: BlueprintLevelData(
      description: 'A criança usa peças grandes enquanto o cão permanece ao lado segurando o cordão com o focinho.',
      materials: ['Cordão grosso', 'Contas grandes de EVA', 'Coleira ou guia para fixar o cordão'],
      steps: [
        'Convide o cão para deitar ao lado da criança.',
        'Mostre como o cordão fica apoiado no cão e ofereça duas peças por vez.',
        'Ajude a criança a empurrar cada pérola até o final do cordão.',
      ],
      notes: 'Mantenha poucas peças visíveis para não cansar a atenção.',
    ),
    intermediate: BlueprintLevelData(
      description: 'As pérolas ficam menores e o cão se move lentamente, exigindo mais atenção.',
      materials: ['Cordão médio', 'Pérolas médias coloridas', 'Clipe para marcar o começo'],
      steps: [
        'Combine um ritmo com o cão: ele avança um passo a cada duas pérolas.',
        'Estimule a criança a escolher a cor pedida pelo terapeuta.',
        'Peça para alternar a mão dominante durante o encaixe.',
      ],
      notes: 'Se o cão se mover demais, peça para o paciente respirar fundo antes de continuar.',
    ),
    advanced: BlueprintLevelData(
      description: 'A criança cria um padrão longo e apresenta para o cão ao final.',
      materials: ['Cordão fino', 'Pérolas pequenas', 'Cartão com sequência para copiar'],
      steps: [
        'Mostre o cartão com a ordem de cores.',
        'Conte o tempo de cada sequência e peça para refazer mais rápido.',
        'Finalize deixando o cão “levar” o colar até outra pessoa.',
      ],
      notes: 'A sequência pode terminar com um presente para o cão, reforçando o vínculo afetivo.',
    ),
  ),
  DocxExerciseBlueprint(
    id: 'pillow-trail',
    title: 'Trilha das Almofadas',
    subtitle: 'Equilíbrio dinâmico guiado pelo cão',
    pillars: [PsychomotorPillar.motora, PsychomotorPillar.sensorial],
    initial: BlueprintLevelData(
      description: 'A criança pisa em almofadas firmes seguindo o cão em linha reta.',
      materials: ['3 almofadas largas', 'Guia curta', 'Figuras de pegadas'],
      steps: [
        'Monte três almofadas formando uma ponte baixa.',
        'Posicione o cão na frente, caminhando devagar.',
        'Peça para a criança tocar as pegadas adesivas antes de cada passo.',
      ],
      notes: 'Se necessário, segure nas mãos para garantir segurança.',
    ),
    intermediate: BlueprintLevelData(
      description: 'As almofadas ficam alternadas e o cão faz leves curvas.',
      materials: ['5 almofadas com alturas diferentes', 'Cone pequeno', 'Cartões com setas'],
      steps: [
        'Monte zigue-zague com as almofadas.',
        'Use cartões para mostrar para onde o próximo passo deve ir.',
        'O cão para em cada cone esperando a criança encostar nele.',
      ],
      notes: 'Troque a ordem das almofadas para manter o desafio sensorial.',
    ),
    advanced: BlueprintLevelData(
      description: 'A trilha inclui saltos curtos e comandos ao cão.',
      materials: ['Almofadas altas', 'Arco baixo', 'Sinos pequenos'],
      steps: [
        'Espalhe sinos que devem tocar com o pé antes de seguir.',
        'Acrescente um arco para que o cão passe e a criança o siga.',
        'Finalize com ambos sentando juntos para desacelerar.',
      ],
      notes: 'Observe sinais de cansaço e ofereça pausa com carinho no cão.',
    ),
  ),
  DocxExerciseBlueprint(
    id: 'postdog-letters',
    title: 'Cartas do Cão Carteiro',
    subtitle: 'Planejamento e linguagem enquanto o cão entrega pistas',
    pillars: [PsychomotorPillar.cognitiva, PsychomotorPillar.social],
    initial: BlueprintLevelData(
      description: 'A criança encontra envelopes próximos com palavras simples.',
      materials: ['3 envelopes coloridos', 'Etiquetas com figuras', 'Colete para o cão'],
      steps: [
        'Coloque envelopes próximos ao cão.',
        'Cada envelope revela uma ação curta, como “dar um abraço no cão”.',
        'Ajude a criança a completar a ação antes de abrir o próximo envelope.',
      ],
      notes: 'Use palavras já conhecidas para reforçar segurança.',
    ),
    intermediate: BlueprintLevelData(
      description: 'O cão leva envelopes para pontos diferentes e a criança lê pistas curtas.',
      materials: ['6 envelopes numerados', 'Marcadores de chão', 'Prancheta pequena'],
      steps: [
        'Desenhe no chão onde cada envelope será deixado.',
        'Peça para a criança seguir a ordem numérica.',
        'Cada pista exige uma ação com duas etapas (ex.: acariciar o cão e depois caminhar juntos).',
      ],
      notes: 'Reforce o elogio após cada sequência correta.',
    ),
    advanced: BlueprintLevelData(
      description: 'As cartas montam uma história curta que deve ser contada ao final.',
      materials: ['8 envelopes', 'Cartas com trechos da história', 'Adesivos de personagens'],
      steps: [
        'Entregue dois envelopes por vez para estimular memória.',
        'A criança organiza os trechos em ordem.',
        'Finalize contando a história para o cão como se ele fosse o carteiro chefe.',
      ],
      notes: 'Permita que a criança crie falas para o cão respondendo às cartas.',
    ),
  ),
  DocxExerciseBlueprint(
    id: 'bubble-chase',
    title: 'Corrida de Bolhas',
    subtitle: 'Coordenação ampla e engajamento afetivo',
    pillars: [PsychomotorPillar.afetiva, PsychomotorPillar.motora],
    videoUrl: 'https://example.com/video-bolhas',
    initial: BlueprintLevelData(
      description: 'Bolhas grandes estouradas com toques leves enquanto o cão observa.',
      materials: ['Soprador de bolhas grande', 'Tapete antiderrapante'],
      steps: [
        'Sente o cão ao lado e sopre bolhas devagar.',
        'Peça para estourar usando apenas um dedo.',
        'Faça uma pausa para celebrar cada acerto com carinho no cão.',
      ],
      notes: 'Evite escorregões secando o chão entre as rodadas.',
    ),
    intermediate: BlueprintLevelData(
      description: 'O cão segue as bolhas e a criança precisa alcançá-lo.',
      materials: ['Soprador médio', 'Cones para marcar limites'],
      steps: [
        'Marque um percurso curto com cones.',
        'Sopre bolhas ao longo do trajeto enquanto o cão caminha.',
        'A criança tenta estourar antes do cão chegar.',
      ],
      notes: 'Relembre que o objetivo é brincar, não competir.',
    ),
    advanced: BlueprintLevelData(
      description: 'Corrida com comandos: soprar, correr, deitar com o cão.',
      materials: ['Gerador de bolhas pequeno', 'Cartões com verbos simples'],
      steps: [
        'Mostre um cartão para cada rodada (soprar, correr, abraçar).',
        'A criança e o cão cumprem o comando juntos.',
        'Finalize com respiração profunda ao lado do cão.',
      ],
      notes: 'Intercale movimentos rápidos e lentos para cuidar do fôlego.',
    ),
  ),
];
