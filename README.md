
Поддерживаются следующие аргументы:

    name - (Обязательно) Название службы (до 255 букв, цифр, дефисов и знаков подчеркивания)
    task_definition - (обязательно) Семейство и ревизия ( family:revision ) или полный ARN определения задачи, которое вы хотите запустить в своей службе.
    desired_count - (Необязательно) Количество экземпляров определения задачи, которые нужно разместить и продолжить. По умолчанию 0. Не указывайте при использованиистратегии планирования DAEMON .
    launch_type - (Необязательно) Тип запуска, при котором будет запущена ваша служба. Допустимые значения: EC2 и FARGATE . По умолчанию EC2 .
    scheduling_strategy - (Необязательно) Стратегия планирования, используемая для службы. Допустимые значения: REPLICA и DAEMON . По умолчанию REPLICA . Обратите внимание, что задачи Fargate не поддерживают стратегию планирования DAEMON .
    cluster - (Необязательно) ARN кластера ECS
    iam_role - (необязательно) ARN роли IAM, которая позволяет Amazon ECS выполнять вызовы балансировщика нагрузки от вашего имени. Этот параметр является обязательным, если вы используете балансировщик нагрузки со своей службой, но только если в определении вашей задачи не используетсясетевой режим awsvpc . При использованиисетевого режима awsvpc не указывайте эту роль. Если в вашей учетной записи уже создана роль, связанная с сервисом Amazon ECS, эта роль по умолчанию используется для вашего сервиса, если вы не укажете здесь роль.
    deployment_maximum_percent - (Необязательно) Верхний предел (в процентах от желаемого значения службы) количества выполняемых задач, которые могут выполняться в службе во время развертывания. Не действует при использованиистратегии планирования DAEMON .
    deployment_minimum_healthy_percent - (Необязательно) Нижний предел (в процентах от желаемого значения службы) количества выполняемых задач, которые должны оставаться работающими и работоспособными в службе во время развертывания. Не действует при использованиистратегии планирования DAEMON .
    placement_strategy - (опционально) Устаревшее , используйте ordered_placement_strategy вместо этого.
    ordered_placement_strategy - (Необязательно) правила стратегии уровня обслуживания, которые учитываются при размещении задачи. Перечислите сверху вниз в порядке приоритета. Максимальное количествоблоков ordered_placement_strategy - 5 . Определено ниже.
    health_check_grace_period_seconds - (Необязательно) Секунды для игнорирования неудачных проверок работоспособности балансировщика нагрузки для вновь созданных задач, чтобы предотвратить преждевременное завершение работы, до 7200. Действительно только для служб, настроенных для использования балансировщиков нагрузки.
    load_balancer - (Необязательно) Блок балансировки нагрузки. Балансировщики нагрузки описаны ниже.
    placement_constraints - (Необязательно) правила, которые учитываются при размещении задачи. Максимальное количество placement_constraints - 10 . Определено ниже.
    network_configuration - (Необязательно) конфигурация сети для службы. Этот параметр требуется для определений задач, которые используютсетевой режим awsvpc для получения собственного эластичного сетевого интерфейса, и он не поддерживается для других сетевых режимов.
    service_registries - (Необязательно) реестры обнаружения службы для службы. Максимальное количествоблоков service_registries - 1 .

    Примечание. В результате ограничения AWS к load_balancer можно подключить не более одного load_balancer . См. Соответствующие документы .

Балансировщики нагрузки поддерживают следующее:

    elb_name - (Требуется для ELB Classic) Имя ELB (Classic) для связи с услугой.
    target_group_arn - (Требуется для ALB / NLB) ARN целевой группы Load Balancer для связи со службой.
    container_name - (обязательно) имя контейнера, которое нужно связать с балансировщиком нагрузки (как оно указано в определении контейнера).
    container_port - (обязательно) порт на контейнере, который нужно связать с балансировщиком нагрузки.

ordered_placement_strategy

ordered_placement_strategy поддерживает следующее:

    type - (Обязательно) Тип стратегии размещения. Должен быть одним из: binpack , random или spread
    field - (Необязательно) Длястратегии размещения spread допустимыми значениями являются instanceId (или хост, который имеет тот же эффект), или любой атрибут платформы или настраиваемый атрибут, который применяется к экземпляру контейнера. Для binpack типа, допустимые значения memory и cpu . Для random типа этот атрибут не нужен. Для получения дополнительной информации см. Стратегию размещения .

    Примечание: для spread , host и instanceId будут нормализованы, на AWS, чтобы быть instanceId . Это означает, что в файле состояния будет отображаться instanceId , но ваша конфигурация будет отличаться, если вы используете host .

placement_constraints

placement_constraints поддерживает следующее:

    type - (Обязательно) Тип ограничения. Единственные допустимые значения в это время являются memberOf и distinctInstance .
    expression - (Необязательно) выражение языка кластерных запросов, применяемое к ограничению. Не нужно быть указан для distinctInstance типа. Дополнительную информацию см. В разделе Cluster Query Language в Руководстве разработчика Amazon EC2 Container Service .

network_configuration

network_configuration поддерживает следующее:

    subnets - (обязательно) подсети, связанные с задачей или службой.
    security_groups - (необязательно) группы безопасности, связанные с задачей или службой. Если вы не укажете группу безопасности, будет использоваться группа безопасности по умолчанию для VPC.
    assign_public_ip - (Необязательно) Назначьте общедоступный IP-адрес для ENI (только для типа запуска Fargate). Допустимые значения: true или false . По умолчанию false .

Для получения дополнительной информации см. Сеть задач.
service_registries

service_registries поддерживает следующее:

    registry_arn - (Обязательный) ARN реестра служб. В настоящее время поддерживаемый реестр служб - это Amazon Route 53 Auto Naming Service ( aws_service_discovery_service ). Для получения дополнительной информации см. Сервис
    port - (необязательно) значение порта, используемое, если ваша служба обнаружения служб указала запись SRV.
    container_port - (необязательно) значение порта, уже указанное в определении задачи, которое будет использоваться для вашей службы обнаружения служб.
    container_name - (необязательно) значение имени контейнера, уже указанное в определении задачи, которое будет использоваться для вашей службы обнаружения служб.

Атрибуты Ссылка

В дополнение ко всем вышеперечисленным аргументам экспортируются следующие атрибуты:

    id - имя ресурса Amazon (ARN), которое идентифицирует сервис
    name - Название сервиса
    cluster - Имя ресурса Amazon (ARN) кластера, на котором работает служба
    iam_role - ARN роли IAM, используемой для ELB
    desired_count - количество экземпляров определения задачи
