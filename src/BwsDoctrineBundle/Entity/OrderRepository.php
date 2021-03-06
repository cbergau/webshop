<?php

namespace BwsDoctrineBundle\Entity;

use Bws\Entity\Order as BaseOrder;
use Bws\Repository\OrderRepositoryInterface;
use Doctrine\ORM\EntityRepository;

class OrderRepository extends EntityRepository implements OrderRepositoryInterface
{
    /**
     * @param BaseOrder $order
     */
    public function save(BaseOrder $order)
    {
        $this->getEntityManager()->persist($order);
        $this->getEntityManager()->flush();
    }

    /**
     * @return Order
     */
    public function factory()
    {
        return new Order();
    }

    /**
     * @param int $userId
     *
     * @return BaseOrder[]
     */
    public function findByUserId($userId)
    {
        return $this->findBy(array('customer' => $userId));
    }
}
